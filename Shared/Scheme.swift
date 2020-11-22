//
//  Scheme.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 22.11.2020.
//

import SwiftUI


struct CalendarScheme {
    let header: HeaderScheme
    let body: BodyScheme
}

struct HeaderScheme {
    let monthColor: Color
}

struct BodyScheme {
    let weekdayColor: Color
    let weekendColor: Color
    let outOfMonthColor: Color
    let today: SelectionScheme
}

struct SelectionScheme {
    let backgroundColor: Color
    let foregroundColor: Color
}

extension HeaderScheme {
    static let standard: HeaderScheme = .init(
        monthColor: .red
    )
}

extension CalendarScheme {
    static let standard: CalendarScheme = .init(
        header: .standard,
        body: .standard
    )
}

extension BodyScheme {
    static let standard: BodyScheme = .init(
        weekdayColor: .primary,
        weekendColor: .secondary,
        outOfMonthColor: .clear,
        today: .today
    )
}

extension SelectionScheme {
    static let today: SelectionScheme = .init(
        backgroundColor: .red,
        foregroundColor: .white
    )
}
