//
//  IWatchFontsAdjuster.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 13.12.2020.
//

import SwiftUI


struct IWatchFontsAdjuster: ViewModifier {

    func body(content: Content) -> some View {
        #if os(watchOS)
        return GeometryReader { geometry in
            content
                .font(.adjustedIWatchFont(screenHeight: geometry.size.height))
        }
        #else
        return content
        #endif
    }

}

private extension Font {

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
