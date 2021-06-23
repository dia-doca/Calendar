//
//  ShadingEffect.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 13.12.2020.
//

import SwiftUI


struct ShadingEffect: ViewModifier {

    let isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isEnabled ? 0.7 : 1)
            .scaleEffect(isEnabled ? 0.93 : 1)
            .animation(.easeIn)
    }

}

