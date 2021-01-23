//
//  CalendarView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 21.11.2020.
//

import SwiftUI


public struct CalendarView: View {

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
        VStack(alignment: .leading, spacing: 2) {
            CalendarHeaderView(today: today, month: month, calendar: calendar, scheme: scheme.header)
            CalendarBodyView(today: today, month: month, calendar: calendar, scheme: scheme.date)
        }
    }

}
