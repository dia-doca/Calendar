//
//  CalendarDateView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI


struct CalendarDateView: View {

    private let displayedDate: Date
    private let today: Date
    private let month: Date
    private let calendar: Calendar
    private let scheme: DateScheme

    private var title: String { "\(calendar.component(.day, from: displayedDate))" }

    init(displayedDate: Date, today: Date, month: Date, calendar: Calendar, scheme: DateScheme) {
        self.displayedDate = displayedDate
        self.today = today
        self.month = month
        self.calendar = calendar
        self.scheme = scheme
    }

    var body: some View {
        Text(title)
            .modifier(
                CalendarDateLabel(
                    displayedDate: displayedDate,
                    today: today,
                    month: month,
                    calendar: calendar,
                    scheme: scheme
                )
            )
    }

}
