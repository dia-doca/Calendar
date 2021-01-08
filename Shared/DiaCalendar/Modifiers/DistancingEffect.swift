//
//  DistancingEffect.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 13.12.2020.
//

import SwiftUI


struct DistancingEffect: ViewModifier {

    let isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isEnabled ? 0.8 : 1)
            .scaleEffect(isEnabled ? 0.95 : 1)
            .animation(.default)
    }

}

