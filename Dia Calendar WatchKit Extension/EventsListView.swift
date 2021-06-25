//
//  EventsListView.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 20.06.2021.
//

import SwiftUI


struct EventsListView: View {

    private let events: [CalendarEventViewModel]

    init(events: [CalendarEventViewModel]) {
        self.events =  events
    }

    var body: some View {
        completeList
    }

    @ViewBuilder
    private var completeList: some View {
        if events.isEmpty {
            emptyList
        } else {
            eventsLiat
        }
    }

    private var eventsLiat: some View {
        List(events, id: \.self) { event in
            CalendarEventRow(event: event)
        }
    }

    private var emptyList: some View {
        List {
            Text("No events").foregroundColor(.secondary)
        }
    }

}

struct CalendarEventRow: View {

    private let event: CalendarEventViewModel

    init(event: CalendarEventViewModel) {
        self.event = event
    }

    var body: some View {
        HStack(alignment: .center) {
            Rectangle()
                .foregroundColor(Color(event.color))
                .cornerRadius(2)
                .frame(width: 4)
            Text(event.title)
        }
    }

}

struct EventsListView_Previews: PreviewProvider {

    static var previews: some View {

        let list: [CalendarEventViewModel] = [
            CalendarEventViewModel(title: "Какое то важное событие в календаре", color: UIColor.red.cgColor),
            CalendarEventViewModel(title: "Что то сделать", color: UIColor.green.cgColor),
            CalendarEventViewModel(title: "Куда то сходить", color: UIColor.blue.cgColor),
        ]
        ForEach(SimulatorDevices.watches, id: \.self) { device in
            EventsListView(
                events: list
            )
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }

    }

}
