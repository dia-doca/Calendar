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
        return events.map({
            CalendarEventViewModel(title: $0.title, color: $0.calendar.cgColor)
        })
    }

}

struct CalendarEventViewModel: Hashable {
    let title: String
    let color: CGColor
}
