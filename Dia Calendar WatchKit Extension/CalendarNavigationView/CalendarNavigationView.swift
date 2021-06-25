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

    @State private var isShowingCalendarEventsListView = false

    private let scheme: CalendarScheme

    public init(today: Date, calendar: Calendar, scheme: CalendarScheme) {
        self.scheme = scheme
        viewModel = CalendarNavigationViewModel(calendar: calendar, today: today)
    }

    var body: some View {
        ZStack {
            navigationView
            calendarView
            gesturesView
         }
        .modifier(IWatchFontsAdjuster())
        .modifier(IWatchDigitalCrownConnector(digitalCrownRotation: $viewModel.digitalCrownRotation))
        .navigationTitle({ titleView(viewModel.title) })
    }

    private var navigationView: some View {
        NavigationLink(destination: eventsView, isActive: $isShowingCalendarEventsListView) { EmptyView() }.hidden()
    }

    private var calendarView: some View {
        CalendarView(
            today: viewModel.today,
            month: viewModel.currentMonth,
            calendar: viewModel.calendar,
            scheme: scheme
        )
        .modifier(ShadingEffect(isEnabled: viewModel.isSelectorVisible))
    }

    private var gesturesView: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture(count: 1, perform: {
                if viewModel.isToday {
                    isShowingCalendarEventsListView = true
                } else {
                    viewModel.presentMonth(.current)
                }
            })
    }

    private func titleView(_ title: String) -> some View {
        NavigationTitleView(title: title, color: scheme.header.monthColor)
    }

    @ViewBuilder
    private var eventsView: some View {
        if viewModel.isCalendarEventsGranted {
            let list = viewModel.getCalendarEventsList()
            EventsListView(events: list.events)
                .navigationTitle({ titleView(list.title) })
        } else {
            let warning = viewModel.getCalendarEventsAccessDenied()
            Text(warning.message)
                .padding()
                .navigationTitle({ titleView(warning.title) })
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
