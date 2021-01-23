//
//  Scheme.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 22.11.2020.
//

import SwiftUI


public struct CalendarScheme {
    let header: HeaderScheme
    let date: DateScheme
}

public struct HeaderScheme {
    let monthColor: Color
}

public struct DateScheme {
    let weekdayColor: Color
    let weekendColor: Color
    let outOfMonthColor: Color
    let today: SelectionScheme
}

public struct SelectionScheme {
    let backgroundColor: Color
    let foregroundColor: Color
}
