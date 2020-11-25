//
//  Scheme.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 22.11.2020.
//

import SwiftUI


struct CalendarScheme {
    let header: HeaderScheme
    let date: DateScheme
}

struct HeaderScheme {
    let monthColor: Color
}

struct DateScheme {
    let weekdayColor: Color
    let weekendColor: Color
    let outOfMonthColor: Color
    let today: SelectionScheme
}

struct SelectionScheme {
    let backgroundColor: Color
    let foregroundColor: Color
}
