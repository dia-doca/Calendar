//
//  CalendarView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 21.11.2020.
//

import SwiftUI

struct CalendarView: View {

    let today: Date
    let calendar: Calendar
    let scheme: CalendarScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            CalendarHeaderView(calendar: calendar, today: today, scheme: scheme.header)
            CalendarBodyView(calendar: calendar, today: today, scheme: scheme.body)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {

    static var previews: some View {
        CalendarView(
            today: Date(),
            calendar: .makeCalendar(),
            scheme: .standard
        )
        .preferredColorScheme(.light)
    }
}

struct CalendarHeaderView: View {

    let calendar: Calendar
    let today: Date
    let scheme: HeaderScheme

    var body: some View {
        Text(calendar.monthSymbols[calendar.component(.month, from: today) - 1])
            .foregroundColor(scheme.monthColor)
            .textCase(.uppercase)
    }
}

struct CalendarBodyView: View {

    let calendar: Calendar
    let today: Date
    let scheme: BodyScheme

    var body: some View {
        HStack() {
            ForEach(calendar.veryShortWeekdaySymbols.indices) { i in
                VStack(spacing: 2) {
                    CalendarWeekView(weekday: adjustedWeekdayIndex(i) + 1, scheme: scheme, calendar: calendar)
                    ForEach(calendar.daysOfPage(for: Date(), weekday: adjustedWeekdayIndex(i) + 1), id: \.self) { date in
                        CalendarDayView(calendar: calendar, date: date, scheme: scheme)
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

struct CalendarWeekView: View {

    let weekday: Int
    let scheme: BodyScheme
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

struct CalendarDayView: View {

    let calendar: Calendar
    let date: Date
    let scheme: BodyScheme

    var title: String { "\(calendar.component(.day, from: date))" }

    var body: some View {
        if calendar.isDateInToday(date) {
            Text(title)
                .foregroundColor(scheme.today.foregroundColor)
                .background(
                    Circle()
                        .inset(by: -4)
                        .fill(scheme.today.backgroundColor)
                )
        } else if calendar.isDate(date, inSameMonthAs: Date()) {
            if calendar.isDateInWeekend(date) {
                Text(title)
                    .foregroundColor(scheme.weekendColor)
            } else {
                Text(title)
                    .foregroundColor(scheme.weekdayColor)
            }
        } else {
            Text(title)
                .foregroundColor(scheme.outOfMonthColor)
        }
    }

}
