//
//  AdjustedWatchFonts.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 13.12.2020.
//

import SwiftUI


struct AdjustedWatchFonts: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .font(.adjustedIWatchFont(screenHeight: geometry.size.height))
        }
    }
}
