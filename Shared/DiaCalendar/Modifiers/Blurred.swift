//
//  Blurred.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 13.12.2020.
//

import SwiftUI


struct Blurred: ViewModifier {

    let isBlurred: Bool

    func body(content: Content) -> some View {
        content
            .blur(radius: isBlurred ? 8.5 : 0)
            .scaleEffect(isBlurred ? 0.95 : 1)
            .animation(.default)
    }

}

