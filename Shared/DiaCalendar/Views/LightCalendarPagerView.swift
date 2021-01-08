//
//  LightCalendarPagerView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 13.12.2020.
//

import SwiftUI
import Combine

struct LightCalendarPagerView: View {

    let scheme: CalendarScheme

    @ObservedObject var viewModel: LightCalendarPagerViewModel

    var todaysTap: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                viewModel.reset()
            }
    }

    var body: some View {
        ZStack {
            calendarView(month: viewModel.currentMonth)
                .modifier(DistancingEffect(isEnabled: viewModel.isSelectorVisible))
            if viewModel.isSelectorVisible {
                MonthSelectorView(month: viewModel.pickerMonth)
                    .scaleEffect(viewModel.monthSelectorViewScaleFactor)
                #if DEBUG
                Text("\(viewModel.digitalCrownRotation)")
                    .padding()
                    .background(Color.black)
                    .offset(y: 50)
                #endif
            }
         }
        .modifier(IWatchDigitalCrownConnector(digitalCrownRotation: $viewModel.digitalCrownRotation))
        .gesture(todaysTap)

    }

    private func calendarView(month: Date) -> some View {
        CalendarView(
            today: viewModel.today,
            month: month,
            calendar: viewModel.calendar,
            scheme: scheme
        )
    }

}

struct LightCalendarPagerView_Preview: PreviewProvider {

    static var previews: some View {

        ForEach(Devices.watches, id: \.self) { device in
            LightCalendarPagerView(
                scheme: .standard,
                viewModel: LightCalendarPagerViewModel(calendar: .makeCalendar(), today: Date())
            )
            .modifier(IWatchFontsAdjuster())
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }

    }

}
