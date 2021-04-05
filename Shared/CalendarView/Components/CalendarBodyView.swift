//
//  CalendarBodyView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI

struct CalendarBodyView: View, Equatable {

    static func == (lhs: CalendarBodyView, rhs: CalendarBodyView) -> Bool {
        lhs.today == rhs.today && lhs.month == rhs.month
    }

    private let today: Date
    private let month: Date
    private let calendar: Calendar
    private let scheme: DateScheme

    init(today: Date, month: Date, calendar: Calendar, scheme: DateScheme) {
        self.today = today
        self.month = month
        self.calendar = calendar
        self.scheme = scheme
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(calendar.veryShortWeekdaySymbols.indices) { i in
                VStack(spacing: 5) {
                    CalendarWeekView(weekday: adjustedWeekdayIndex(i) + 1, calendar: calendar, scheme: scheme)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    ForEach(calendar.daysOfPage(for: month, weekday: adjustedWeekdayIndex(i) + 1), id: \.self) { date in
                        CalendarDateView(
                            displayedDate: date,
                            today: today,
                            month: month,
                            calendar: calendar,
                            scheme: scheme
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
    }

    private func adjustedWeekdayIndex(_ index: Int) -> Int {
        let weekdaysCount = calendar.weekdaySymbols.count
        let firstWeekday = calendar.firstWeekday
        return (index + (firstWeekday - 1)) % weekdaysCount
    }

}
