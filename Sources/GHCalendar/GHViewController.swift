//
//  File.swift
//  
//
//  Created by Soltan Gheorghe on 19.11.2020.
//


import SwiftUI

struct GHViewController: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var ghManager: GHManager
    
    var body: some View {
        Group {
            GHWeekdayHeader(ghManager: self.ghManager)
            Divider()
            List {
                ForEach(0..<numberOfMonths()) { index in
                    GHMonth(isPresented: self.$isPresented, ghManager: self.ghManager, monthOffset: index)
                }
                Divider()
            }
        }
    }
    
    func numberOfMonths() -> Int {
        return ghManager.calendar.dateComponents([.month], from: ghManager.minimumDate, to: RKMaximumDateMonthLastDay()).month! + 1
    }
    
    func RKMaximumDateMonthLastDay() -> Date {
        var components = ghManager.calendar.dateComponents([.year, .month, .day], from: ghManager.maximumDate)
        components.month! += 1
        components.day = 0
        
        return ghManager.calendar.date(from: components)!
    }
}

#if DEBUG
struct RKViewController_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            GHViewController(isPresented: .constant(false), ghManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0))
            GHViewController(isPresented: .constant(false), ghManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*32), mode: 0))
                .environment(\.colorScheme, .dark)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
#endif
