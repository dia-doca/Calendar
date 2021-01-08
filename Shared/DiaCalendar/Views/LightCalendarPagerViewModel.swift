//
//  LightCalendarPagerViewModel.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 16.12.2020.
//

import SwiftUI
import Combine

class LightCalendarPagerViewModel: ObservableObject {

    @Published var isSelectorVisible = false
    @Published var monthSelectorViewScaleFactor: CGFloat = 0.0

    @Published var digitalCrownRotation = 0.0

    @Published var pickerMonth = Date()
    @Published var currentMonth = Date()

    let today: Date
    let calendar: Calendar

    @Published private var monthOffset = 0.0
    private var bag = Set<AnyCancellable>()

    init(calendar: Calendar, today: Date) {
        self.calendar = calendar
        self.today = today
        currentMonth = today
        bind()
    }

    func reset() {
        digitalCrownRotation = 0
    }

    private func bind() {

        $digitalCrownRotation
            .dropFirst()
            .throttle(for: 0.1, scheduler: RunLoop.main, latest: true)
            .map { [weak self] crownRotation in
                guard let strongSelf = self else { return 0.0 }
                let monthComponent = crownRotation > strongSelf.monthOffset ? floor(crownRotation) : ceil(crownRotation)
                return monthComponent
            }
            .assign(to: \.monthOffset, on: self)
            .store(in: &bag)

        $digitalCrownRotation
            .dropFirst()
            .throttle(for: 0.1, scheduler: RunLoop.main, latest: true)
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
            .debounce(for: 0.3, scheduler: RunLoop.main)
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
            .throttle(for: 0.1, scheduler: RunLoop.main, latest: false)
            .map { _ in true }
            .assign(to: \.isSelectorVisible, on: self)
            .store(in: &bag)

    }

}
