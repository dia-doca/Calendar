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
            NavigationLink(destination: detailsView(for: event)) {
                CalendarEventRow(event: event)
            }
        }
    }

    private var emptyList: some View {
        List {
            Text("No events").foregroundColor(.secondary)
        }
    }

    private func detailsView(for event: CalendarEventViewModel) -> some View {
        EventDetailsView(event: event).navigationTitle("Event")
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
            VStack(alignment: .leading) {
                Text(event.title)
                Group {
                    if event.isAllDay {
                        Text("All-day event")
                    } else {
                        Text(event.localizedInterval)
                    }
                }
                .font(.footnote)
                .foregroundColor(.secondary)
            }
        }
    }

}

struct EventDetailsView: View {

    let event: CalendarEventViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if event.isAllDay {
                    Text("All-day event")
                } else {
                    Text(event.localizedInterval)
                }
                descriptionView(title: "Calendar", description: event.calendar).foregroundColor(Color(event.color))
                if event.hasRecurrenceRules, let localizedRecurrenceRules = event.localizedRecurrenceRules {
                    descriptionView(title: "Repeats", description: localizedRecurrenceRules)
                }
                if let location = event.location {
                    descriptionView(title: "Location", description: location)
                }
                if let notes = event.notes {
                    descriptionView(title: "Notes", description: notes)
                }
            }

        }
    }

    private func descriptionView(title: String, description: String) -> some View {
        VStack(alignment: .leading) {
            Text(title).foregroundColor(.secondary).font(.footnote)
            Text(description)
        }
    }

}

struct EventsListView_Previews: PreviewProvider {

    static var previews: some View {

        let now = Date()
        let calendar = Calendar.current
        let inFiveMin = calendar.date(byAdding: DateComponents(minute: 5), to: now)!

        let list: [CalendarEventViewModel] = [
            CalendarEventViewModel(
                title: "Какое то важное событие в календаре",
                color: UIColor.red.cgColor,
                calendar: "BD's",
                startDate: now,
                endDate: inFiveMin,
                isAllDay: false,
                location: "somewhere",
                notes: "notes notes notes notes notes notes notes notes 123456",
                hasRecurrenceRules: true,
                frequency: .monthly,
                interval: 2
            )
        ]

        EventDetailsView(event: list.first!)

//        ForEach(SimulatorDevices.watches, id: \.self) { device in
//            EventsListView(
//                events: list
//            )
//            .previewDevice(PreviewDevice(rawValue: device))
//            .previewDisplayName(device)
//        }

    }

}

private extension CalendarEventViewModel {

    var localizedInterval: String {
        "\(DateFormatter.timeFormatter.string(from: startDate)) - \(DateFormatter.timeFormatter.string(from: endDate))"
    }

    var localizedRecurrenceRules: String? {
        guard hasRecurrenceRules, let frequency = frequency, let interval = interval else { return nil }
        switch frequency {
        case .daily:
            return "every \(interval) days"
        case .weekly:
            return "every \(interval) weeks"
        case .monthly:
            return "every \(interval) months"
        case .yearly:
            return "every \(interval) years"
        @unknown default:
            return nil
        }
    }

}

private extension DateFormatter {

    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

}
