//
//  CalendarHeaderView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI


struct CalendarHeaderView: View {

    let calendar: Calendar
    let today: Date
    let month: Date
    let scheme: HeaderScheme

    var body: some View {
        HStack {
            Text(calendar.monthSymbols[calendar.component(.month, from: month) - 1])
            if calendar.isDate(today, inSameYearAs: month) == false {
                Spacer()
                Text(month.string(for: .year))
                    .layoutPriority(.greatestFiniteMagnitude)
            }
        }
        .foregroundColor(scheme.monthColor)
        .textCase(.uppercase)
        .lineLimit(1)
    }
    
}
