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
    let scheme: HeaderScheme

    var body: some View {
        Text(calendar.monthSymbols[calendar.component(.month, from: today) - 1])
            .foregroundColor(scheme.monthColor)
            .textCase(.uppercase)
    }
}
