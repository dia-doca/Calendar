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

    public init(today: Date, calendar: Calendar, scheme: CalendarScheme) {
        self.scheme = scheme
        viewModel = CalendarNavigationViewModel(calendar: calendar, today: today)
    }

    var body: some View {
        ZStack {
            calendarView()
            monthSelectorView()
            gestureNavigation()
         }
        .modifier(IWatchFontsAdjuster())
        .modifier(IWatchDigitalCrownConnector(digitalCrownRotation: $viewModel.digitalCrownRotation))
    }

    private func calendarView() -> some View {
        CalendarView(
            today: viewModel.today,
            month: viewModel.currentMonth,
            calendar: viewModel.calendar,
            scheme: scheme
        )
        .modifier(ShadingEffect(isEnabled: viewModel.isSelectorVisible))
    }

    private func monthSelectorView() -> some View {
        Group {
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
    }

    private func gestureNavigation() -> some View {
        VStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.presentMonth(.previous)
                }
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(count: 2, perform: {
                    viewModel.presentMonth(.current)
                })
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.presentMonth(.next)
                }
        }
    }

}

struct LightCalendarPagerView_Preview: PreviewProvider {

    static var previews: some View {

        ForEach(SimulatorDevices.watches, id: \.self) { device in
            CalendarNavigationView(
                today: Date(),
                calendar: Calendar.current,
                scheme: .standard
            )
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }

    }

}
