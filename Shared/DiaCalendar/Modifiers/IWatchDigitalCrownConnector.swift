//
//  IWatchDigitalCrownConnector.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 28.12.2020.
//

import SwiftUI


struct IWatchDigitalCrownConnector: ViewModifier {

    let digitalCrownRotation: Binding<Double>

    func body(content: Content) -> some View {

        #if os(watchOS)
        return content
            .focusable(true)
            .digitalCrownRotation(
                digitalCrownRotation,
                from: -1_000.0,
                through: 1_000.0,
                by: 1.0,
                sensitivity: .low,
                isContinuous: true,
                isHapticFeedbackEnabled: true
            )
        #else
        return content
        #endif

    }

}

