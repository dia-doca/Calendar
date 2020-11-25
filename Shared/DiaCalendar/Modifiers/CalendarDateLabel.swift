//
//  CalendarDateLabel.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI


struct CalendarDateLabel: ViewModifier {

    let date: Date
    let calendar: Calendar
    let scheme: DateScheme

    enum DayType {
        case today
        case weekday
        case weekend
        case outOfMonth
    }

    func body(content: Content) -> some View {
        Group {
            switch getDayType(from: date, calendar: calendar) {
            case .today:
                content.foregroundColor(scheme.today.foregroundColor)
                    .background(
                        Circle()
                            .inset(by: -2)
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
        case _ where calendar.isDateInToday(date):
            return .today
        case _ where calendar.isDate(date, inSameMonthAs: Date()) && calendar.isDateInWeekend(date):
            return .weekend
        case _ where calendar.isDate(date, inSameMonthAs: Date()):
            return .weekday
        default:
            return .outOfMonth
        }
    }

}

