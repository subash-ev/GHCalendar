//
//  File.swift
//  
//
//  Created by Soltan Gheorghe on 19.11.2020.
//


import SwiftUI

struct GHWeekdayHeader : View {
    
    var ghManager: GHManager
     
    var body: some View {
        HStack(alignment: .center) {
            ForEach(self.getWeekdayHeaders(calendar: self.ghManager.calendar), id: \.self) { weekday in
                Text(weekday)
                    .font(.system(size: 20))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(self.ghManager.colors.weekdayHeaderColor)
            }
        }.background(ghManager.colors.weekdayHeaderBackColor)
    }
    
    func getWeekdayHeaders(calendar: Calendar) -> [String] {
        
        let formatter = DateFormatter()
        
        var weekdaySymbols = formatter.shortStandaloneWeekdaySymbols
        let weekdaySymbolsCount = weekdaySymbols?.count ?? 0
        
        for _ in 0 ..< (1 - calendar.firstWeekday + weekdaySymbolsCount){
            let lastObject = weekdaySymbols?.last
            weekdaySymbols?.removeLast()
            weekdaySymbols?.insert(lastObject!, at: 0)
        }
        
        return weekdaySymbols ?? []
    }
}

#if DEBUG
struct RKWeekdayHeader_Previews : PreviewProvider {
    static var previews: some View {
        GHWeekdayHeader(ghManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0))
    }
}
#endif
