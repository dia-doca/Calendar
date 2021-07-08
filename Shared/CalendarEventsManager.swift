//
//  CalendarEventsManager.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 17.06.2021.
//

import UIKit
import EventKit
import Combine


final class CalendarEventsManager {

    @Published private (set) var isGranted = false

    private lazy var store = EKEventStore()

    private var bag = Set<AnyCancellable>()

    func requestAccess() {
        store.requestAccess(to: .event) { [weak self] granted, error in
            guard let strongSelf = self else { return }
            Just(granted)
                .receive(on: DispatchQueue.main)
                .assign(to: &strongSelf.$isGranted)
        }
    }

    func getTodaysEvents() -> [CalendarEventViewModel] {
        guard isGranted else { return [] }
        let calendar = Calendar.current
        let today = Date()
        let start = calendar.startOfDay(for: today)
        let end = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: start) ?? today
        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)
        let events = store.events(matching: predicate)
        return events
            .sorted(by: { $0.startDate < $1.startDate })
            .map({
            CalendarEventViewModel(
                title: $0.title,
                color: $0.calendar.cgColor,
                calendar: $0.calendar.title,
                startDate: $0.startDate,
                endDate: $0.endDate,
                isAllDay: $0.isAllDay,
                location: $0.location,
                notes: $0.hasNotes ? $0.notes : nil,
                hasRecurrenceRules: $0.hasRecurrenceRules,
                frequency: $0.recurrenceRules?.first?.frequency,
                interval: $0.recurrenceRules?.first?.interval
            )
        })
    }

}

struct CalendarEventViewModel: Hashable {
    let title: String
    let color: CGColor
    let calendar: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
    let location: String?
    let notes: String?
    let hasRecurrenceRules: Bool
    let frequency: EKRecurrenceFrequency?
    let interval: Int?
}
