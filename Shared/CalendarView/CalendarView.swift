//
//  CalendarView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 21.11.2020.
//

import SwiftUI


public struct CalendarView: View, Equatable {

    public static func == (lhs: CalendarView, rhs: CalendarView) -> Bool {
        lhs.today == rhs.today && lhs.month == rhs.month
    }

    private let today: Date
    private let month: Date
    private let calendar: Calendar
    private let scheme: CalendarScheme

    public init(today: Date, month: Date, calendar: Calendar, scheme: CalendarScheme) {
        self.today = today
        self.month = month
        self.calendar = calendar
        self.scheme = scheme
    }

    public var body: some View {
        VStack(alignment: .leading) {
            if !scheme.header.isHidden {
                CalendarHeaderView(today: today, month: month, calendar: calendar, scheme: scheme.header)
            }
            CalendarBodyView(today: today, month: month, calendar: calendar, scheme: scheme.date).equatable()
        }
    }

}
