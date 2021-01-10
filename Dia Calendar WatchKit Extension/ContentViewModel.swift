//
//  ContentViewModel.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 10.01.2021.
//

import SwiftUI
import Combine
import DiaCalendarPackage


extension ContentView {

    final class ViewModel: ObservableObject {

        enum Event {
            case onAppear
        }

        @Published private(set) var today = Date()
        let calendar = Calendar.current
        let scheme: CalendarScheme = .standard

        private var bag = Set<AnyCancellable>()
        private var timer: Timer?

        init() {
            configureApplicationObserver()
        }

        func sendEvent(_ event: Event) {
            switch event {
            case .onAppear:
                onAppear()
            }
        }

        // MARK: Private

        @objc
        private func updateCurrentDate() {
            today = calendar.date(byAdding: DateComponents(day: 1), to: today)!
        }

        private func configureApplicationObserver() {
            NotificationCenter.default.publisher(for: WKExtension.applicationWillEnterForegroundNotification)
                .sink { [weak self] notification in
                    guard let strongSelf = self else { return }
                    if !strongSelf.calendar.isDateInToday(strongSelf.today) {
                        strongSelf.today = Date()
                    }
                }
                .store(in: &bag)
        }

        private func onAppear() {
            timer?.invalidate()
            let startOfToday = calendar.startOfDay(for: Date())
            let startOfTomorrow = calendar.date(byAdding: DateComponents(day: 1), to: startOfToday)!
            let secondsInDay: TimeInterval = 24 * 60 * 60
            let timer = Timer(
                fireAt: startOfTomorrow,
                interval: secondsInDay,
                target: self,
                selector: #selector(updateCurrentDate),
                userInfo: nil,
                repeats: true
            )
            RunLoop.main.add(timer, forMode: .common)
        }

    }

}
