//
//  YearView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 31.01.2021.
//

import SwiftUI


public struct YearView: View {

    private let today: Date
    private let year: Date
    private let calendar: Calendar
    private let scheme: CalendarScheme

    public init(today: Date, year: Date, calendar: Calendar, scheme: CalendarScheme) {
        self.today = today
        self.year = year
        self.calendar = calendar
        self.scheme = scheme
    }

    public var body: some View {

        VStack(spacing: 16) {
            ForEach(0..<4) { row in
                HStack(alignment: .top) {
                    ForEach(1..<4) { m in
                        CalendarView(
                            today: today,
                            month: month(m + row * 3, from: year),
                            calendar: Calendar.current,
                            scheme: .standard
                        ).equatable()
                    }
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .font(.system(size: 10))
        .minimumScaleFactor(0.01)
    }

    private func month(_ month: Int, from year: Date) -> Date {
        let year = calendar.dateComponents([.year], from: year).year!
        return calendar.date(from: DateComponents(year: year, month: month))!
    }

}

struct YearView_Previews: PreviewProvider {

    static var previews: some View {
        YearView(
            today: Date(),
            year: Date(),
            calendar: Calendar.current,
            scheme: .standard
        )
    }

}
