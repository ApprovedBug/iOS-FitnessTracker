//
//  AddDiaryEntryViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 02/08/2024.
//

import Combine
import DependencyManagement
@preconcurrency import FitnessPersistence
import FitnessServices
import FitnessUI
import Foundation
import SwiftUI
import Utilities

@Observable
@MainActor
class AddDiaryEntryViewModel {
    
    struct EventHandler {
        var diaryEntryAdded: (DiaryEntry) -> Void
        var diaryEntriesAdded: ([DiaryEntry]) -> Void
    }
    
    enum State {
        case idle
        case searchResults(items: [FoodItemViewModel], meals: [MealItemViewModel])
        case empty
    }
    
    var isShowingCreateNewFoodItem: Bool = false
    var isShowingAddExistingItem: Bool = false
    var isShowingError: Bool = false
    var showToast: Bool = false
    var shouldDismiss: Bool = false
    var searchTerm: String = ""
    var state: State = .idle
    var addFoodItemViewModel: AddFoodItemViewModel?
    var barcodeScannerView: IdentifiableView?
    var errorMessage: String?
    var recentItems: [FoodItemViewModel]?
    var mealFoodItems: [MealItemViewModel]?
    
    let date: Date
    let mealType: MealType
    let eventHandler: EventHandler?
    
    @ObservationIgnored
    @Inject private var foodItemRepository: FoodItemRepository
    
    @ObservationIgnored
    @Inject private var diaryRepository: DiaryRepository
    
    @ObservationIgnored
    @Inject private var mealsRepository: MealsRepository
    
    @ObservationIgnored
    @Inject private var barcodeScanner: BarcodeScanning
    
    @ObservationIgnored
    @Inject private var foodItemService: FoodInfoNetworking
    
    @ObservationIgnored
    private var cancellables = [AnyCancellable]()
    
    @ObservationIgnored
    private var meals: [Meal] = []
    
    @ObservationIgnored
    private lazy var itemEventHandler: FoodItemViewModel.EventHandler = {
        FoodItemViewModel.EventHandler { [weak self] foodItem async in
            await self?.addDiaryEntry(foodItem)
        }
    }()
    
    @ObservationIgnored
    private lazy var mealItemEventHandler: MealItemViewModel.EventHandler = {
        MealItemViewModel.EventHandler { [weak self] meal async in
            await self?.addMeal(meal)
        }
    }()
    
    @ObservationIgnored
    private lazy var createItemEventHandler: AddFoodItemViewModel.EventHandler = {
        AddFoodItemViewModel.EventHandler(
            didCreateFoodItem: { [weak self] item in
                guard let self else { return }
                await addDiaryEntry(item)
                shouldDismiss = true
            }) { [weak self] foodItem, servings in
                await self?.addDiaryEntry(foodItem, servings: servings)
            }
    }()
    
    init(date: Date, mealType: MealType, eventHandler: EventHandler? = nil) {
        self.date = date
        self.mealType = mealType
        self.eventHandler = eventHandler
    }
    
    @MainActor
    func createFoodItemTapped() {
        let viewModel = AddFoodItemViewModel(eventHandler: createItemEventHandler)
        addFoodItemViewModel = viewModel
        isShowingCreateNewFoodItem = true
    }
    
    @MainActor
    func addFoodItemTapped(_ foodItem: FoodItem) {
        let viewModel = AddFoodItemViewModel(eventHandler: createItemEventHandler, foodItem: foodItem)
        addFoodItemViewModel = viewModel
        isShowingAddExistingItem = true
    }
    
    @MainActor
    func scanItemTapped() async {
        do {
            
            let scanner = try await barcodeScanner.scanner()
            
            barcodeScanner.barcodes
                .sink { [weak self] barcode in
                    Task {
                        await self?.dismissScannerAndSearch(barcode: barcode)
                    }
                }
                .store(in: &cancellables)
            
            barcodeScannerView = IdentifiableView(view: scanner)
        } catch {
            errorMessage = "Error loading scanner view."
            isShowingError = true
        }
    }
    
    @MainActor
    func scannerPresented() async {
        do {
            try await barcodeScanner.startScanning()
        } catch {
            errorMessage = "Error starting scanning."
            isShowingError = true
        }
    }
    
    @MainActor
    func dismissScannerAndSearch(barcode: String) async {
        await barcodeScanner.stopScanning()
        barcodeScannerView = nil
        
        Task.detached(priority: .background) { [weak self] in
            guard let self = self else { return }
            
            do {
                let foodInfo = try await foodItemService.search(barcode: barcode)
    
                await self.openFoodProduct(foodInfo)
            } catch {
                await MainActor.run {
                    self.errorMessage = "Product not found."
                    isShowingError = true
                }
            }
        }
    }
    
    @MainActor
    func openFoodProduct(_ foodProduct: FoodProduct) async {
        
        guard let foodItem = FoodItem(from: foodProduct) else {
            errorMessage = "Missing required nutrients."
            isShowingError = true
            return
        }
        
        addFoodItemTapped(foodItem)
    }
    
    @MainActor
    func loadInitialState() async {
        
        await loadRecentItems()
            .zip(await loadMeals())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
            switch completion {
                case .finished:
                    break
                case .failure:
                    self?.state = .empty
            }
        }, receiveValue: { [weak self] results in
            guard let self else { return }
            recentItems = results.0.map { FoodItemViewModel(foodItem: $0, eventHandler: itemEventHandler) }
            mealFoodItems = results.1.map { MealItemViewModel(meal: $0, eventHandler: mealItemEventHandler) }
            showResults(items: recentItems, meals: mealFoodItems)
        })
        .store(in: &cancellables)
    }
    
    @MainActor
    func loadRecentItems() async -> AnyPublisher<Set<FoodItem>, Never> {
        await foodItemRepository.recentFoodItems().replaceError(with: []).eraseToAnyPublisher()
    }
    
    @MainActor
    func loadMeals() async -> AnyPublisher<[Meal], Never> {
        await mealsRepository.meals().replaceError(with: []).eraseToAnyPublisher()
    }
    
    @MainActor
    func search() async {
        Task.detached(priority: .background) { [weak self] in
            guard let self = self else { return }
            
            do {
                let foodProducts = try await foodItemService.search(searchTerm: searchTerm)
    
                guard !foodProducts.isEmpty else {
                    await MainActor.run {
                        state = .empty
                    }
                    return
                }
                
                let foodItems = foodProducts.map({ FoodItem(from: $0) }).compactMap({$0})
                
                guard !foodItems.isEmpty else {
                    await MainActor.run {
                        state = .empty
                    }
                    return
                }
                await MainActor.run {
                    let items = foodItems.map { FoodItemViewModel(foodItem: $0, eventHandler: itemEventHandler) }
                    showResults(items: items, meals: mealFoodItems)
                }
                
            } catch {
                await MainActor.run {
                    self.errorMessage = "Product not found."
                    isShowingError = true
                }
            }
        }
    }
    
    func filter() {
    
        guard !searchTerm.isEmpty else {
            showResults(items: recentItems, meals: mealFoodItems)
            return
        }
        
        let items = recentItems?.filter { item in
            item.name.localizedCaseInsensitiveContains(searchTerm)
        }
        
        let meals = mealFoodItems?.filter { item in
            item.name.localizedCaseInsensitiveContains(searchTerm)
        }
        
        showResults(items: items, meals: meals)
    }
    
    func showResults(items: [FoodItemViewModel]? = [], meals: [MealItemViewModel]? = []) {
        
        state = .searchResults(items: items ?? [], meals: meals ?? [])
    }
    
    func clearSearch() async {
        await loadInitialState()
    }
    
    @MainActor
    func addDiaryEntry(_ foodItem: FoodItem, servings: Double = 1) async {
        let diaryEntry = DiaryEntry(timestamp: date, foodItem: foodItem, mealType: mealType, servings: servings)
        await diaryRepository.addDiaryEntry(diaryEntry: diaryEntry)
        eventHandler?.diaryEntryAdded(diaryEntry)
        showToast = true
    }
    
    @MainActor
    func addMeal(_ meal: Meal?) async {
        guard let meal else { return }
        
        let diaryEntries = meal.foodItems.map { mealFoodItem in
            DiaryEntry(
                timestamp: date,
                foodItem: mealFoodItem.foodItem,
                mealType: mealType,
                servings: mealFoodItem.servings
            )
        }
        await diaryRepository.addDiaryEntries(diaryEntries: diaryEntries)
        eventHandler?.diaryEntriesAdded(diaryEntries)
        showToast = true
    }
}

extension FoodItem {
    
    convenience init?(from foodProduct: FoodProduct) {
        
        guard let kcal = foodProduct.nutriments.energyKcal100g,
              let carbs = foodProduct.nutriments.carbohydrates100g,
              let protein = foodProduct.nutriments.proteins100g,
              let fats = foodProduct.nutriments.fat100g else {
            return nil
        }

        self.init(
            name: foodProduct.productName,
            kcal: Int(kcal),
            carbs: carbs,
            protein: protein,
            fats: fats,
            measurementUnit: .grams,
            servingSize: 100
        )
    }
}
