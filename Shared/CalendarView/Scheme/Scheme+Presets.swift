//
//  Scheme+Presets.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI

public extension CalendarScheme {
    static let standard: CalendarScheme = .init(
        header: .standard,
        date: .standard
    )
}

extension HeaderScheme {
    #if os(watchOS)
    static let standard: HeaderScheme = .init(monthColor: .red, isHidden: true)
    #else
    static let standard: HeaderScheme = .init(monthColor: .red, isHidden: false)
    #endif
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
