//
//  ContentViewModel.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 10.01.2021.
//

import SwiftUI
import Combine


extension ContentView {

    final class ViewModel: ObservableObject {

        @Published private (set) var today = Date()
        @Published private (set) var isEventsPageAvailable = false

        private let eventsManager = CalendarEventsManager()
        
        let calendar = Calendar.current
        let scheme: CalendarScheme = .standard

        private var bag = Set<AnyCancellable>()
        private var timer: Timer?

        init() {
            configureApplicationObserver()
            activateMidnightTimer()
            eventsManager.requestAccess()
            eventsManager.$isGranted.assign(to: &$isEventsPageAvailable)
        }

        // MARK: Private

        @objc
        private func updateTodaysDate() {
            today = Date()
        }

        private func configureApplicationObserver() {
            NotificationCenter.default.publisher(for: WKExtension.applicationWillEnterForegroundNotification)
                .sink { [weak self] notification in
                    guard let strongSelf = self else { return }
                    if strongSelf.calendar.isDateInToday(strongSelf.today) == false {
                        strongSelf.updateTodaysDate()
                    }
                    strongSelf.activateMidnightTimer()
                }
                .store(in: &bag)
        }

        private func activateMidnightTimer() {
            timer?.invalidate()
            let tomorrow = calendar.date(byAdding: DateComponents(day: 1), to: Date())!
            let startOfTomorrow = calendar.startOfDay(for: tomorrow)
            let timer = Timer(
                fireAt: startOfTomorrow,
                interval: 0,
                target: self,
                selector: #selector(updateTodaysDate),
                userInfo: nil,
                repeats: false
            )
            self.timer = timer
            RunLoop.main.add(timer, forMode: .common)
        }

    }

}
