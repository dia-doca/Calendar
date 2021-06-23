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

    @Published private (set) var events = [CalendarEventViewModel]()
    @Published private (set) var isGranted = false

    private lazy var store = EKEventStore()

    private var bag = Set<AnyCancellable>()

    init() {
        addRequestEventsObserver()
    }

    func requestAccess() {
        store.requestAccess(to: .event) { [weak self] granted, error in
            guard let strongSelf = self else { return }
            Just(granted)
                .receive(on: DispatchQueue.main)
                .assign(to: &strongSelf.$isGranted)
        }
    }

    private func addRequestEventsObserver() {
        $isGranted
            .filter({ $0 })
            .sink(receiveValue: { [unowned self] _ in self.events = self.todaysEvents() })
            .store(in: &bag)
    }

    func todaysEvents() -> [CalendarEventViewModel] {
        let today = Date()
        let predicate = store.predicateForEvents(withStart: today, end: today, calendars: nil)
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
