//
//  Scheme+Presets.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI

extension CalendarScheme {
    static let standard: CalendarScheme = .init(
        header: .standard,
        date: .standard
    )
}

extension HeaderScheme {
    static let standard: HeaderScheme = .init(
        monthColor: .red
    )
}

extension DateScheme {
    static let standard: DateScheme = .init(
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
