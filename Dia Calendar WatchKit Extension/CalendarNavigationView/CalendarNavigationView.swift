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
            gestureNavigation()
         }
        .modifier(IWatchFontsAdjuster())
        .modifier(IWatchDigitalCrownConnector(digitalCrownRotation: $viewModel.digitalCrownRotation))
        .navigationTitle({ titleView() })
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

    private func titleView() -> some View {
        HStack {
            Text(viewModel.title)
                .foregroundColor(scheme.header.monthColor)
            Spacer()
        }
        .animation(.none)
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
