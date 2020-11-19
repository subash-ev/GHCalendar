//
//  SwiftUIView.swift
//  
//
//  Created by Soltan Gheorghe on 19.11.2020.
//

import SwiftUI


import SwiftUI

struct GHCell: View {
    
    var GHDate: GHDate
    
    var cellWidth: CGFloat
    
    var body: some View {
        Text(GHDate.getText())
            .fontWeight(GHDate.getFontWeight())
            .foregroundColor(GHDate.getTextColor())
            .frame(width: cellWidth, height: cellWidth)
            .font(.system(size: 20))
            .background(GHDate.getBackgroundColor())
            .cornerRadius(cellWidth/2)
    }
}

#if DEBUG
struct RKCell_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            GHCell(GHDate: GHDate(date: Date(), rkManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), isDisabled: false, isToday: false, isSelected: false, isBetweenStartAndEnd: false), cellWidth: CGFloat(32))
                .previewDisplayName("Control")
            GHCell(GHDate: GHDate(date: Date(), rkManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), isDisabled: true, isToday: false, isSelected: false, isBetweenStartAndEnd: false), cellWidth: CGFloat(32))
                .previewDisplayName("Disabled Date")
            GHCell(GHDate: GHDate(date: Date(), rkManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), isDisabled: false, isToday: true, isSelected: false, isBetweenStartAndEnd: false), cellWidth: CGFloat(32))
                .previewDisplayName("Today")
            GHCell(GHDate: GHDate(date: Date(), rkManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), isDisabled: false, isToday: false, isSelected: true, isBetweenStartAndEnd: false), cellWidth: CGFloat(32))
                .previewDisplayName("Selected Date")
            GHCell(GHDate: GHDate(date: Date(), rkManager: GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), isDisabled: false, isToday: false, isSelected: false, isBetweenStartAndEnd: true), cellWidth: CGFloat(32))
                .previewDisplayName("Between Two Dates")
        }
        .previewLayout(.fixed(width: 300, height: 70))
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
