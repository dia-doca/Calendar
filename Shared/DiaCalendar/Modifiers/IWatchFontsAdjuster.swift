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
