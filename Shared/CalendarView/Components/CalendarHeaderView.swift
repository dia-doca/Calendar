//
//  CalendarHeaderView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI


struct CalendarHeaderView: View {

    private let today: Date
    private let month: Date
    private let calendar: Calendar
    private let scheme: HeaderScheme

    init(today: Date, month: Date, calendar: Calendar, scheme: HeaderScheme) {
        self.today = today
        self.month = month
        self.calendar = calendar
        self.scheme = scheme
    }

    var body: some View {
        HStack {
            Text(calendar.monthSymbols[calendar.component(.month, from: month) - 1].uppercased())
            if calendar.isDate(today, inSameYearAs: month) == false {
                Spacer()
                Text(month.string(for: .year))
                    .layoutPriority(.greatestFiniteMagnitude)
            }
        }
        .foregroundColor(scheme.monthColor)
        .lineLimit(1)
    }
    
}
