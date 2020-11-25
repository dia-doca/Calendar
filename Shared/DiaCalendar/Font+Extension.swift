//
//  Font+Extension.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 24.11.2020.
//

import SwiftUI


extension Font {
    static func adjustedIWatchFont(screenHeight height: CGFloat) -> Font {
        if height == 174 {  // 3 - 42
            return .system(size: 15, design: .default)

        } else if height == 151 {   // 3 - 38
            return .system(size: 13, design: .default)

        } else if height == 162 {   // 6 - 44
            return .system(size: 17, design: .default)

        } else if height == 141 {   // 6 - 40
            return .system(size: 15, design: .default)

        } else {
            return .system(size: 13, design: .default)

        }
    }
}
