# GHCalendar
**GHCalendar** is a SwiftUI Calendar / Date Picker for iOS.

Features include:

- minimum and maximum calendar dates selectable,
- single date selection, 
- range of dates selection, 
- multi-dates selection, 
- disabled dates setting.

# Requirements
- iOS 13.0+
- Xcode 11+
- Swift 5.1+

# Installation

## Calendar minimum and maximum date setting

Setting the calendar, minimum and maximum dates that can be selected.

    GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)

## Single date selection

Use mode 0 to select a single date.

    GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: 0)

## Range of dates selection

Use mode 1 to select a contiguous range of dates, from a start date to an end date.

    GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: 1)

Note, mode 2 is automatically toggled internally and the end date must be greater than the start date.

## Multi-dates selection

Use mode 3 for selecting a number of dates.

    GHManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: 3)
    
## Full exmaple 
    struct TransfersFilterView: View {
    
        @ObservedObject var calendarManager: GHManager = GHManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-2*60*60*24*365), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 1)



        var body: some View {
            VStack {
                Button(action: {
                  self.isShowingDatePicker = true
                }) {
                    Text("Show Date picker")
                }
            }.padding()
            .sheet(isPresented: $isShowingDatePicker, content: {
                GHDatePicker(isPresented: $isShowingDatePicker, ghManager: calendarManager)
            })
        }
    }
