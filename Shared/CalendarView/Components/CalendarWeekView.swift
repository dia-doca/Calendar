//
//  CalendarWeekView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI


struct CalendarWeekView: View {

    private let weekday: Int
    private let calendar: Calendar
    private let scheme: DateScheme

    init(weekday: Int, calendar: Calendar, scheme: DateScheme) {
        self.weekday = weekday
        self.calendar = calendar
        self.scheme = scheme
    }

    var body: some View {
        Text(calendar.veryShortWeekdaySymbols[weekday - 1])
            .foregroundColor(
                calendar.isWeekdayInWeekend(weekday)
                    ? scheme.weekendColor
                    : scheme.weekdayColor
            )
            .fixedSize()
    }

}
