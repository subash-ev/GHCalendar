//
//  File.swift
//  
//
//  Created by Soltan Gheorghe on 19.11.2020.
//


import SwiftUI

public struct GHDatePicker: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var ghManager: GHManager
    
    public init(isPresented: Binding<Bool>, ghManager: GHManager) {
            self._isPresented = isPresented
            self.ghManager = ghManager
    }
    
    public var body: some View {
    
        if #available(iOS 14.0, *) {
            ScrollViewReader { proxy in
                Group {
                    GHWeekdayHeader(ghManager: self.ghManager)
                    Divider()
                    List {
                        ForEach(0..<numberOfMonths()) { index in
                            GHMonth(isPresented: self.$isPresented, ghManager: self.ghManager, monthOffset: index)
                                .id(index)
                        }
                        Divider()
                    }
                }.onAppear {
                    debugPrint("Appeared.. gh date picker")
                    proxy.scrollTo(numberOfMonths()-1, anchor: .bottom)
                }
                
            }
        } else {
            
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
            
            // Fallback on earlier versions
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
            GHDatePicker(isPresented: .constant(false), ghManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0))
            GHDatePicker(isPresented: .constant(false), ghManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*32), mode: 0))
                .environment(\.colorScheme, .dark)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
#endif
