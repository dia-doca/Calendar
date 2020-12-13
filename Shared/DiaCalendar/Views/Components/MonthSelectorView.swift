//
//  MonthSelectorView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 13.12.2020.
//

import SwiftUI


struct MonthSelectorView: View {

    let month: Date

    var body: some View {
        VStack {
            Text(month.string(for: .month))
                .font(.title2)
                .lineLimit(1)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .padding(.horizontal, 8)
            Text(month.string(for: .year))
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.sRGB, red: 0.15, green: 0.15, blue: 0.15, opacity: 0.7))
        )
    }
    
}
