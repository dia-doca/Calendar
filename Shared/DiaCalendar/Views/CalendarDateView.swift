//
//  CalendarDateView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI


struct CalendarDateView: View {

    let date: Date
    let calendar: Calendar
    let scheme: DateScheme

    var title: String { "\(calendar.component(.day, from: date))" }

    var body: some View {
        Text(title)
            .modifier(
                CalendarDateLabel(
                    date: date,
                    calendar: calendar,
                    scheme: scheme
                )
            )
    }

}
