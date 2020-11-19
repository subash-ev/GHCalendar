//
//  SwiftUIView.swift
//  
//
//  Created by Soltan Gheorghe on 19.11.2020.
//

import SwiftUI

struct GHMonth: View {

    @Binding var isPresented: Bool
    
    @ObservedObject var ghManager: GHManager
    
    let monthOffset: Int
    
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    let daysPerWeek = 7
    var monthsArray: [[Date]] {
        monthArray()
    }
    let cellWidth = CGFloat(32)
    
    @State var showTime = false
    
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.center, spacing: 10){
            Text(getMonthHeader()).foregroundColor(self.ghManager.colors.monthHeaderColor)
            VStack(alignment: .leading, spacing: 5) {
                ForEach(monthsArray, id:  \.self) { row in
                    HStack() {
                        ForEach(row, id:  \.self) { column in
                            HStack() {
                                Spacer()
                                if self.isThisMonth(date: column) {
                                    GHCell(GHDate: GHDate(
                                        date: column,
                                        rkManager: self.ghManager,
                                        isDisabled: !self.isEnabled(date: column),
                                        isToday: self.isToday(date: column),
                                        isSelected: self.isSpecialDate(date: column),
                                        isBetweenStartAndEnd: self.isBetweenStartAndEnd(date: column)),
                                        cellWidth: self.cellWidth)
                                        .onTapGesture { self.dateTapped(date: column) }
                                } else {
                                    Text("").frame(width: self.cellWidth, height: self.cellWidth)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
        }.background(ghManager.colors.monthBackColor)
    }

     func isThisMonth(date: Date) -> Bool {
         return self.ghManager.calendar.isDate(date, equalTo: firstOfMonthForOffset(), toGranularity: .month)
     }
    
    func dateTapped(date: Date) {
        if self.isEnabled(date: date) {
            switch self.ghManager.mode {
            case 0:
                if self.ghManager.selectedDate != nil &&
                    self.ghManager.calendar.isDate(self.ghManager.selectedDate, inSameDayAs: date) {
                    self.ghManager.selectedDate = nil
                } else {
                    self.ghManager.selectedDate = date
                }
                self.isPresented = false
            case 1:
                self.ghManager.startDate = date
                self.ghManager.endDate = nil
                self.ghManager.mode = 2
            case 2:
                self.ghManager.endDate = date
                if self.isStartDateAfterEndDate() {
                    self.ghManager.endDate = nil
                    self.ghManager.startDate = nil
                }
                self.ghManager.mode = 1
                self.isPresented = false
            case 3:
                if self.ghManager.selectedDatesContains(date: date) {
                    if let ndx = self.ghManager.selectedDatesFindIndex(date: date) {
                        ghManager.selectedDates.remove(at: ndx)
                    }
                } else {
                    self.ghManager.selectedDates.append(date)
                }
            default:
                self.ghManager.selectedDate = date
                self.isPresented = false
            }
        }
    }
     
    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) {
            var columnArray = [Date]()
            for column in 0 ... 6 {
                let abc = self.getDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
        return rowArray
    }
    
    func getMonthHeader() -> String {
        let headerDateFormatter = DateFormatter()
        headerDateFormatter.calendar = ghManager.calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy LLLL", options: 0, locale: ghManager.calendar.locale)
        
        return headerDateFormatter.string(from: firstOfMonthForOffset()).uppercased()
    }
    
    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthForOffset()
        let weekday = ghManager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - ghManager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset
        
        return ghManager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }
    
    func numberOfDays(offset : Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = ghManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)
        
        return (rangeOfWeeks?.count)! * daysPerWeek
    }
    
    func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        
        return ghManager.calendar.date(byAdding: offset, to: RKFirstDateMonth())!
    }
    
    func RKFormatDate(date: Date) -> Date {
        let components = ghManager.calendar.dateComponents(calendarUnitYMD, from: date)
        
        return ghManager.calendar.date(from: components)!
    }
    
    func RKFormatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = RKFormatDate(date: referenceDate)
        let clampedDate = RKFormatDate(date: date)
        return refDate == clampedDate
    }
    
    func RKFirstDateMonth() -> Date {
        var components = ghManager.calendar.dateComponents(calendarUnitYMD, from: ghManager.minimumDate)
        components.day = 1
        
        return ghManager.calendar.date(from: components)!
    }
    
    // MARK: - Date Property Checkers
    
    func isToday(date: Date) -> Bool {
        return RKFormatAndCompareDate(date: date, referenceDate: Date())
    }
     
    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) ||
            isStartDate(date: date) ||
            isEndDate(date: date) ||
            isOneOfSelectedDates(date: date)
    }
    
    func isOneOfSelectedDates(date: Date) -> Bool {
        return self.ghManager.selectedDatesContains(date: date)
    }

    func isSelectedDate(date: Date) -> Bool {
        if ghManager.selectedDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: ghManager.selectedDate)
    }
    
    func isStartDate(date: Date) -> Bool {
        if ghManager.startDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: ghManager.startDate)
    }
    
    func isEndDate(date: Date) -> Bool {
        if ghManager.endDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: ghManager.endDate)
    }
    
    func isBetweenStartAndEnd(date: Date) -> Bool {
        if ghManager.startDate == nil {
            return false
        } else if ghManager.endDate == nil {
            return false
        } else if ghManager.calendar.compare(date, to: ghManager.startDate, toGranularity: .day) == .orderedAscending {
            return false
        } else if ghManager.calendar.compare(date, to: ghManager.endDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    func isOneOfDisabledDates(date: Date) -> Bool {
        return self.ghManager.disabledDatesContains(date: date)
    }
    
    func isEnabled(date: Date) -> Bool {
        let clampedDate = RKFormatDate(date: date)
        if ghManager.calendar.compare(clampedDate, to: ghManager.minimumDate, toGranularity: .day) == .orderedAscending || ghManager.calendar.compare(clampedDate, to: ghManager.maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return !isOneOfDisabledDates(date: date)
    }
    
    func isStartDateAfterEndDate() -> Bool {
        if ghManager.startDate == nil {
            return false
        } else if ghManager.endDate == nil {
            return false
        } else if ghManager.calendar.compare(ghManager.endDate, to: ghManager.startDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
}

#if DEBUG
struct RKMonth_Previews : PreviewProvider {
    static var previews: some View {
        GHMonth(isPresented: .constant(false),ghManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), monthOffset: 0)
    }
}
#endif
