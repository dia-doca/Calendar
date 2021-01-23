//
//  CalendarDateLabel.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI


struct CalendarDateLabel: ViewModifier {

    private let displayedDate: Date
    private let today: Date
    private let month: Date
    private let calendar: Calendar
    private let scheme: DateScheme

    enum DayType {
        case today
        case weekday
        case weekend
        case outOfMonth
    }

    init(displayedDate: Date, today: Date, month: Date, calendar: Calendar, scheme: DateScheme) {
        self.displayedDate = displayedDate
        self.today = today
        self.month = month
        self.calendar = calendar
        self.scheme = scheme
    }

    func body(content: Content) -> some View {
        Group {
            switch getDayType(from: displayedDate, calendar: calendar) {
            case .today:
                content.foregroundColor(scheme.today.foregroundColor)
                    .background(
                        Circle()
                            .inset(by: -6)
                            .offset(y: 1)
                            .fill(scheme.today.backgroundColor)
                    )
            case .weekday:
                content.foregroundColor(scheme.weekdayColor)
            case .weekend:
                content.foregroundColor(scheme.weekendColor)
            case .outOfMonth:
                content.foregroundColor(scheme.outOfMonthColor)
            }
        }
    }

    private func getDayType(from date: Date, calendar: Calendar) -> DayType {
        switch date {
        case _ where calendar.isDate(date, inSameMonthAs: month) && calendar.isDate(date, inSameDayAs: today):
            return .today
        case _ where calendar.isDate(date, inSameMonthAs: month) && calendar.isDateInWeekend(date):
            return .weekend
        case _ where calendar.isDate(date, inSameMonthAs: month):
            return .weekday
        default:
            return .outOfMonth
        }
    }

}

