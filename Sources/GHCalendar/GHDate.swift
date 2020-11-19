//
//  SwiftUIView.swift
//  
//
//  Created by Soltan Gheorghe on 19.11.2020.
//

import SwiftUI

struct GHDate {
    
    var date: Date
    let ghManager: GHManager
    
    var isDisabled: Bool = false
    var isToday: Bool = false
    var isSelected: Bool = false
    var isBetweenStartAndEnd: Bool = false
    
    init(date: Date, rkManager: GHManager, isDisabled: Bool, isToday: Bool, isSelected: Bool, isBetweenStartAndEnd: Bool) {
        self.date = date
        self.ghManager = rkManager
        self.isDisabled = isDisabled
        self.isToday = isToday
        self.isSelected = isSelected
        self.isBetweenStartAndEnd = isBetweenStartAndEnd
    }
    
    func getText() -> String {
        let day = formatDate(date: date, calendar: self.ghManager.calendar)
        return day
    }
    
    func getTextColor() -> Color {
        var textColor = ghManager.colors.textColor
        if isDisabled {
            textColor = ghManager.colors.disabledColor
        } else if isSelected {
            textColor = ghManager.colors.selectedColor
        } else if isToday {
            textColor = ghManager.colors.todayColor
        } else if isBetweenStartAndEnd {
            textColor = ghManager.colors.betweenStartAndEndColor
        }
        return textColor
    }
    
    func getBackgroundColor() -> Color {
        var backgroundColor = ghManager.colors.textBackColor
        if isBetweenStartAndEnd {
            backgroundColor = ghManager.colors.betweenStartAndEndBackColor
        }
        if isToday {
            backgroundColor = ghManager.colors.todayBackColor
        }
        if isDisabled {
            backgroundColor = ghManager.colors.disabledBackColor
        }
        if isSelected {
            backgroundColor = ghManager.colors.selectedBackColor
        }
        return backgroundColor
    }
    
    func getFontWeight() -> Font.Weight {
        var fontWeight = Font.Weight.medium
        if isDisabled {
            fontWeight = Font.Weight.thin
        } else if isSelected {
            fontWeight = Font.Weight.heavy
        } else if isToday {
            fontWeight = Font.Weight.heavy
        } else if isBetweenStartAndEnd {
            fontWeight = Font.Weight.heavy
        }
        return fontWeight
    }
    
    // MARK: - Date Formats
    
    func formatDate(date: Date, calendar: Calendar) -> String {
        let formatter = dateFormatter()
        return stringFrom(date: date, formatter: formatter, calendar: calendar)
    }
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"
        return formatter
    }
    
    func stringFrom(date: Date, formatter: DateFormatter, calendar: Calendar) -> String {
        if formatter.calendar != calendar {
            formatter.calendar = calendar
        }
        return formatter.string(from: date)
    }
}
