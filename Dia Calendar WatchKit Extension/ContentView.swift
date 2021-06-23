//
//  ContentView.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 23.11.2020.
//

import SwiftUI


struct ContentView: View {

    @ObservedObject private var viewModel = ViewModel()

    var body: some View {
        makeContentView()
    }

    @ViewBuilder
    private func makeContentView() -> some View {
        if viewModel.isEventsPageAvailable {
            pageControllerView
        } else {
            calendarView
        }
    }

    private var pageControllerView: some View {
        PageControllerView(pageCount: 2) {
            calendarView
            eventsView
        }

    }

    private var calendarView: some View {
        CalendarNavigationView(
            today: viewModel.today,
            calendar: viewModel.calendar,
            scheme: viewModel.scheme
        )
    }

    private var eventsView: some View {
        EventsListView(events: viewModel.todaysEvents)
    }

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
    
}
