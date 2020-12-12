//
//  Calendar+Extension.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 22.11.2020.
//

import Foundation


extension Calendar {

    func isDate(_ date1: Date, inSameYearAs date2: Date) -> Bool {
        dateComponents([.year], from: date1) == dateComponents([.year], from: date2)
    }

    func isDate(_ date1: Date, inSameMonthAs date2: Date) -> Bool {
        dateComponents([.year, .month], from: date1) == dateComponents([.year, .month], from: date2)
    }

    func isWeekdayInWeekend(_ weekday: Int) -> Bool {
        var result = false
        enumerateDates(startingAfter: Date.distantPast, matching: DateComponents(weekday: weekday), matchingPolicy: .strict) { (date, flag, stop) in
            guard let date = date else { stop = true; return }
            result = isDateInWeekend(date)
            stop = true
        }
        return result
    }

    func daysOfPage(for date: Date, weekday: Int) -> [Date] {
        let startDate = startOfPage(for: date)
        let endDate = endOfPage(for: date)
        let searchDate = self.date(byAdding: DateComponents(day: -1), to: startDate)!
        var weekDays: [Date] = []
        enumerateDates(startingAfter: searchDate, matching: DateComponents(weekday: weekday), matchingPolicy: .strict) { (date, flag, stop) in
            guard let date = date, date <= endDate else { stop = true; return }
            weekDays.append(date)
        }
        return weekDays
    }

    private func startOfPage(for date: Date) -> Date {
        startOfWeek(for: startOfMonth(for: date))
    }

    private func endOfPage(for date: Date) -> Date {
        endOfWeek(for: endOfMonth(for: date))
    }

    private func startOfMonth(for date: Date) -> Date {
        self.date(from:
                    dateComponents([.year, .month], from: date)
        )!
    }

    private func endOfMonth(for date: Date) -> Date {
        self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(for: date))!
    }

    private func startOfWeek(for date: Date) -> Date {
        let weekOfYearComponents = dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        return self.date(
            from: DateComponents(
                year: weekOfYearComponents.year,
                weekOfYear: weekOfYearComponents.weekOfYear,
                yearForWeekOfYear: weekOfYearComponents.yearForWeekOfYear
            )
        )!
    }

    private func endOfWeek(for date: Date) -> Date {
        self.date(byAdding: DateComponents(day: -1, weekOfYear: 1), to: startOfWeek(for: date))!
    }

}

extension Calendar {
    static func makeCalendar() -> Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }
}
