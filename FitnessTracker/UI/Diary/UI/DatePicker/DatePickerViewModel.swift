//
//  DatePickerViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import Combine
import Foundation

@Observable
class DatePickerViewModel {
    
    private(set) var date: PassthroughSubject<Date, Never> = .init()
    
    @ObservationIgnored
    var currentSelectedDate: Date {
        didSet {
            setTitle()
        }
    }
    
    var title: String = ""
    
    init(date: Date) {
        self.currentSelectedDate = date
        setTitle()
    }
    
    func nextDay() {
        currentSelectedDate = Calendar.current.date(byAdding: .day, value: 1, to: currentSelectedDate)!
        date.send(currentSelectedDate)
    }
    
    func previousDay() {
        currentSelectedDate = Calendar.current.date(byAdding: .day, value: -1, to: currentSelectedDate)!
        date.send(currentSelectedDate)
    }
    
    func setTitle() {
        title = currentSelectedDate.formatted(date: .long, time: .omitted)
    }
}
