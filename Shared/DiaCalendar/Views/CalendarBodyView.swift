//
//  CalendarBodyView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI

struct CalendarBodyView: View {

    let calendar: Calendar
    let today: Date
    let scheme: DateScheme

    var body: some View {
        HStack(spacing: 0) {
            ForEach(calendar.veryShortWeekdaySymbols.indices) { i in
                VStack(spacing: 2) {
                    CalendarWeekView(weekday: adjustedWeekdayIndex(i) + 1, scheme: scheme, calendar: calendar)
                    ForEach(calendar.daysOfPage(for: Date(), weekday: adjustedWeekdayIndex(i) + 1), id: \.self) { date in
                        CalendarDateView(date: date, calendar: calendar, scheme: scheme)
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
