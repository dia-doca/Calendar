//
//  CalendarNavigationView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 13.12.2020.
//

import SwiftUI
import Combine

struct CalendarNavigationView: View {

    @ObservedObject private var viewModel: CalendarNavigationViewModel

    private let scheme: CalendarScheme

    private var todaysTap: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                viewModel.reset()
            }
    }

    init(today: Date, calendar: Calendar, scheme: CalendarScheme) {
        self.scheme = scheme
        viewModel = CalendarNavigationViewModel(calendar: calendar, today: today)
    }

    var body: some View {
        ZStack {
            calendarView(month: viewModel.currentMonth)
                .modifier(ShadingEffect(isEnabled: viewModel.isSelectorVisible))
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
        .modifier(IWatchFontsAdjuster())
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

        ForEach(SimulatorDevices.watches, id: \.self) { device in
            CalendarNavigationView(
                today: Date(),
                calendar: .makeCalendar(),
                scheme: .standard
            )
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }

    }

}
