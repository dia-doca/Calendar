//
//  CalendarWeekView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI


struct CalendarWeekView: View {

    let weekday: Int
    let scheme: DateScheme
    let calendar: Calendar

    var body: some View {
        if calendar.isWeekdayInWeekend(weekday) {
            Text(calendar.veryShortWeekdaySymbols[weekday - 1])
                .foregroundColor(scheme.weekendColor)
        } else {
            Text(calendar.veryShortWeekdaySymbols[weekday - 1])
                .foregroundColor(scheme.weekdayColor)
        }
    }

}
