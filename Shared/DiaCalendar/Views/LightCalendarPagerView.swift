//
//  LightCalendarPagerView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 13.12.2020.
//

#if os(watchOS)

import SwiftUI
import Combine

struct LightCalendarPagerView: View {

    let scheme: CalendarScheme

    @ObservedObject var viewModel: LightCalendarPagerViewModel

    var todaysGesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                viewModel.reset()
            }
    }

    var combinedGesture: some Gesture {
        todaysGesture
    }

    var body: some View {
        ZStack {
            calendarView(month: viewModel.currentMonth)
                .modifier(Blurred(isBlurred: viewModel.isSelectorVisible))
            if viewModel.isSelectorVisible {
                MonthSelectorView(month: viewModel.pickerMonth)
            }
         }
        .gesture(combinedGesture)
        .focusable(true)
        .digitalCrownRotation(
            $viewModel.digitalCrownRotation,
            from: -1_000.0,
            through: 1_000.0,
            by: 1.0,
            sensitivity: .low,
            isContinuous: true,
            isHapticFeedbackEnabled: true
        )
    }

    private func calendarView(month: Date) -> some View {
        CalendarView(
            today: viewModel.today,
            month: month,
            calendar: viewModel.calendar,
            scheme: scheme
        )
    }

}

struct LightCalendarPagerView_Preview: PreviewProvider {

    static var previews: some View {

        ForEach(PreviewDevices.watches, id: \.self) { device in
            LightCalendarPagerView(
                scheme: .standard,
                viewModel: LightCalendarPagerViewModel(calendar: .makeCalendar(), today: Date())
            )
                .modifier(AdjustedWatchFonts())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }

    }

}

class LightCalendarPagerViewModel: ObservableObject {

    @Published var isSelectorVisible = false
    @Published var digitalCrownRotation = 0.0

    @Published var pickerMonth: Date = Date()
    @Published var currentMonth: Date = Date()

    let today: Date
    let calendar: Calendar

    private var bag = Set<AnyCancellable>()

    init(calendar: Calendar, today: Date) {
        self.calendar = calendar
        self.today = today
        pickerMonth = today
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
                guard let strongSelf = self else { return Date() }
                return strongSelf.calendar.date(byAdding: DateComponents(month: Int(trunc(crownRotation))), to: strongSelf.today)!
            }
            .assign(to: \.pickerMonth, on: self)
            .store(in: &bag)

        $pickerMonth
            .dropFirst()
            .debounce(for: 0.3, scheduler: RunLoop.main)
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

#endif
