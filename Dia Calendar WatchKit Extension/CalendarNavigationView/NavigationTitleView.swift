//
//  NavigationTitleView.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 25.06.2021.
//

import SwiftUI


struct NavigationTitleView: View {

    let title: String
    let color: Color

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(color)
            Spacer()
        }
        .animation(.none)
    }

}
