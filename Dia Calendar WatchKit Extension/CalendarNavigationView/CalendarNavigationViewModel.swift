//
//  CalendarNavigationViewModel.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 16.12.2020.
//

import SwiftUI
import Combine

class CalendarNavigationViewModel: ObservableObject {

    @Published var digitalCrownRotation = 0.0
    var isToday: Bool { digitalCrownRotation == 0 }

    @Published private (set) var isSelectorVisible = false
    @Published private (set) var monthSelectorViewScaleFactor: CGFloat = 0.0

    @Published private (set) var pickerMonth = Date()
    @Published private (set) var currentMonth = Date()

    @Published private (set) var title = ""

    @Published private (set) var isCalendarEventsGranted = false

    private let eventsManager = CalendarEventsManager()

    let today: Date
    let calendar: Calendar

    enum Month {
        case previous
        case current
        case next
    }

    @Published private var monthOffset = 0.0
    private var bag = Set<AnyCancellable>()

    init(calendar: Calendar, today: Date) {
        self.calendar = calendar
        self.today = today
        currentMonth = today
        bind()
        configureEvents()
    }

    func presentMonth(_ month: Month) {
        switch month {
        case .previous:
            digitalCrownRotation -= 1
        case .current:
            digitalCrownRotation = 0
        case .next:
            digitalCrownRotation += 1
        }
        playFeedback()
    }

    func getCalendarEventsList() -> (title: String, events: [CalendarEventViewModel]) {
        (title: "Today", events: eventsManager.getTodaysEvents())
    }

    func getCalendarEventsAccessDenied() -> (title: String, message: String) {
        (title: "Events", message: "Access to the calendar is not granted. Grant access from the system settings.")
    }

    private func bind() {

        let throttleDuration: RunLoop.SchedulerTimeType.Stride = 0.05

        $pickerMonth
            .map({ [unowned self] date in makeTitle(from: date) })
            .assign(to: \.title, on: self)
            .store(in: &bag)

        $digitalCrownRotation
            .dropFirst()
            .throttle(for: throttleDuration, scheduler: RunLoop.main, latest: true)
            .map { [weak self] crownRotation in
                guard let strongSelf = self else { return 0.0 }
                let monthComponent = crownRotation > strongSelf.monthOffset ? floor(crownRotation) : ceil(crownRotation)
                return monthComponent
            }
            .assign(to: \.monthOffset, on: self)
            .store(in: &bag)

        $digitalCrownRotation
            .dropFirst()
            .throttle(for: throttleDuration, scheduler: RunLoop.main, latest: true)
            .map { [weak self] rotation in
                guard let strongSelf = self else { return 0.0 }
                return 1.0 + CGFloat(abs(rotation - strongSelf.monthOffset)).bounded(in: 0...1) * 0.3
            }
            .assign(to: \.monthSelectorViewScaleFactor, on: self)
            .store(in: &bag)

        $monthOffset
            .dropFirst()
            .map { [weak self] offset in
                guard let strongSelf = self else { return Date() }
                return strongSelf.calendar.date(byAdding: DateComponents(month: Int(offset)), to: strongSelf.today)!
            }
            .assign(to: \.pickerMonth, on: self)
            .store(in: &bag)

        $monthOffset
            .dropFirst()
            .debounce(for: throttleDuration, scheduler: RunLoop.main)
            .map { [weak self] offset in
                guard let strongSelf = self else { return Date() }
                return strongSelf.calendar.date(byAdding: DateComponents(month: Int(offset)), to: strongSelf.today)!
            }
            .assign(to: \.currentMonth, on: self)
            .store(in: &bag)

        $currentMonth
            .dropFirst()
            .map { _ in false }
            .assign(to: \.isSelectorVisible, on: self)
            .store(in: &bag)

        $digitalCrownRotation
            .dropFirst()
            .throttle(for: throttleDuration, scheduler: RunLoop.main, latest: false)
            .map { _ in true }
            .assign(to: \.isSelectorVisible, on: self)
            .store(in: &bag)

    }

    private func configureEvents() {
        eventsManager.requestAccess()
        eventsManager.$isGranted.assign(to: &$isCalendarEventsGranted)
    }

    private func makeTitle(from date: Date) -> String {
        calendar.isDate(date, inSameYearAs: today)
            ? date.string(for: .month)
            : date.string(for: .monthShort) + " '" + date.string(for: .year)
    }

    private func playFeedback() {
        WKInterfaceDevice.current().play(.click)
    }

}
