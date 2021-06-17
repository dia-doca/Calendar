//
//  CalendarEventsManager.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 17.06.2021.
//

import Foundation
import EventKit
import Combine


final class CalendarEventsManager {

    @Published private (set) var events = [String]()
    @Published private (set) var isGranted = false

    private lazy var store = EKEventStore()

    init() {
    }

    func requestAccess() {
        store.requestAccess(to: .event) { [weak self] granted, error in
            guard let strongSelf = self else { return }
            Just(granted)
                .receive(on: DispatchQueue.main)
                .assign(to: &strongSelf.$isGranted)
        }
    }

}
