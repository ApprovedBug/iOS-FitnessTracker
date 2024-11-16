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
    
    struct ItemListViewModel {
        var isLoading: Bool = false
        var foodItemViewModels: [FoodItemViewModel] = []
    }
    
    var isShowingCreateNewFoodItem: Bool = false
    var isShowingAddExistingItem: Bool = false
    var isShowingError: Bool = false
    var showToast: Bool = false
    var shouldDismiss: Bool = false
    var searchTerm: String = ""
    var addFoodItemViewModel: AddFoodItemViewModel?
    var barcodeScannerView: IdentifiableView?
    var errorMessage: String?
    var itemListViewModel = ItemListViewModel()
    var mealItemViewModels: [MealItemViewModel] = []
    
    let date: Date
    let mealType: MealType
    let eventHandler: EventHandler?
    
    private var recentItems: [FoodItem] = []
    private var meals: [Meal] = []
    
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
    private lazy var itemEventHandler: FoodItemViewModel.EventHandler = {
        FoodItemViewModel.EventHandler { [weak self] foodItem async in
            await self?.addDiaryEntry(foodItem)
        }
    }()
    
    @ObservationIgnored
    private lazy var mealItemEventHandler: MealItemViewModel.EventHandler = {
        MealItemViewModel.EventHandler(
            addMealTapped: { [weak self] meal async in
                await self?.addMeal(meal)
        }, deleteMealTapped: { [weak self] meal in
            self?.deleteMeal(meal)
        })
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
        
        loadInitialState()
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
    func loadInitialState() {
        recentItems = Array(foodItemRepository.recentFoodItems())
        meals = mealsRepository.meals()
        
        showResults(items: recentItems, meals: meals)
    }
    
    @MainActor
    func search() async {
        
        itemListViewModel = ItemListViewModel(isLoading: true, foodItemViewModels: [])
        
        Task.detached(priority: .background) { [weak self] in
            guard let self = self else { return }
            
            do {
                let foodProducts = try await foodItemService.search(searchTerm: searchTerm)
                
                if !foodProducts.isEmpty {
                    let foodItems = foodProducts.map({ FoodItem(from: $0) }).compactMap({$0})
                    
                    await MainActor.run {
                        showResults(items: foodItems, meals: meals)
                    }
                } else {
                    await MainActor.run {
                        self.errorMessage = "Product not found."
                        isShowingError = true
                        showResults(items: recentItems, meals: meals)
                    }
                }
                
            } catch {
                await MainActor.run {
                    self.errorMessage = "Product not found."
                    isShowingError = true
                    showResults(items: recentItems, meals: meals)
                }
            }
        }
    }
    
    func filter() {
    
        guard !searchTerm.isEmpty else {
            showResults(items: recentItems, meals: meals)
            return
        }
        
        let items = recentItems.filter { item in
            item.name.localizedCaseInsensitiveContains(searchTerm)
        }
        
        let meals = meals.filter { item in
            item.name.localizedCaseInsensitiveContains(searchTerm)
        }
        
        showResults(items: items, meals: meals)
    }
    
    func showResults(items: [FoodItem], meals: [Meal]) {
        let foodItemViewModels = items.map { FoodItemViewModel(foodItem: $0, eventHandler: itemEventHandler) }
        
        itemListViewModel = ItemListViewModel(isLoading: false, foodItemViewModels: foodItemViewModels)
        mealItemViewModels = meals.map { MealItemViewModel(meal: $0, eventHandler: mealItemEventHandler) }
    }
    
    func clearSearch() async {
        showResults(items: recentItems, meals: meals)
    }
    
    @MainActor
    func addDiaryEntry(_ foodItem: FoodItem, servings: Double = 1) async {
        let diaryEntry = DiaryEntry(timestamp: date, foodItem: foodItem, mealType: mealType, servings: servings)
        await diaryRepository.addDiaryEntry(diaryEntry: diaryEntry)
        eventHandler?.diaryEntryAdded(diaryEntry)
        showToast = true
    }
    
    @MainActor
    func addMeal(_ meal: Meal) async {
        
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
    
    @MainActor
    func deleteMeal(_ meal: Meal) {
        mealsRepository.deleteMeal(meal)
        meals.removeAll { $0.id == meal.id }
        mealItemViewModels = meals.map { MealItemViewModel(meal: $0, eventHandler: mealItemEventHandler) }
    }
}

private extension FoodItem {
    
    convenience init?(from foodProduct: FoodProduct) {
        if let nutriments = foodProduct.nutrimentsForServing() {
            let (servingQuantity, measurementUnit) = foodProduct.servingSizeAndUnit()
            
            self.init(
                name: foodProduct.productName,
                kcal: Int(nutriments.kcal),
                carbs: nutriments.carbs,
                protein: nutriments.protein,
                fats: nutriments.fats,
                measurementUnit: measurementUnit,
                servingSize: Int(servingQuantity)
            )
        } else if let nutriments = foodProduct.nutrimentsPer100g() {
            self.init(
                name: foodProduct.productName,
                kcal: Int(nutriments.kcal),
                carbs: nutriments.carbs,
                protein: nutriments.protein,
                fats: nutriments.fats,
                measurementUnit: .grams,
                servingSize: 100
            )
        } else {
            return nil
        }
    }
}

// MARK: - Helper Functions
private extension FoodProduct {
    
    /// Extracts serving size and measurement unit
    func servingSizeAndUnit() -> (Double, MeasurementUnit) {
        let measurementUnit = MeasurementUnit(rawValue: servingQuantityUnit ?? "") ?? .item
        let servingQuantity = servingQuantity ?? 1
        return (servingQuantity, measurementUnit)
    }
    
    /// Extracts nutriments for serving size, if available
    func nutrimentsForServing() -> (kcal: Double, carbs: Double, protein: Double, fats: Double)? {
        guard let kcal = nutriments.energyKcalServing,
              let carbs = nutriments.carbohydratesServing,
              let protein = nutriments.proteinsServing,
              let fats = nutriments.fatServing else {
            return nil
        }
        return (kcal, carbs, protein, fats)
    }
    
    /// Extracts nutriments per 100g, if available
    func nutrimentsPer100g() -> (kcal: Double, carbs: Double, protein: Double, fats: Double)? {
        guard let kcal = nutriments.energyKcal100g,
              let carbs = nutriments.carbohydrates100g,
              let protein = nutriments.proteins100g,
              let fats = nutriments.fat100g else {
            return nil
        }
        return (kcal, carbs, protein, fats)
    }
}
