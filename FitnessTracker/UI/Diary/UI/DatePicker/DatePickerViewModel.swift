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
        
        if Calendar.current.isDateInYesterday(currentSelectedDate)
            || Calendar.current.isDateInToday(currentSelectedDate)
            || Calendar.current.isDateInTomorrow(currentSelectedDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            title = dateFormatter.string(from: currentSelectedDate)
        } else {
            
            title = currentSelectedDate.formatted(
                Date.FormatStyle()
                    .year(.defaultDigits)
                    .month(.abbreviated)
                    .day(.twoDigits)
                    .weekday(.abbreviated)
            )
        }
    }
}
