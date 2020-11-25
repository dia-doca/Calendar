//
//  CalendarView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 21.11.2020.
//

import SwiftUI
import UIKit


struct CalendarView: View {

    let today: Date
    let calendar: Calendar
    let scheme: CalendarScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            CalendarHeaderView(calendar: calendar, today: today, scheme: scheme.header)
            CalendarBodyView(calendar: calendar, today: today, scheme: scheme.date)
        }
    }

}

struct CalendarView_Previews: PreviewProvider {

    static var previews: some View {
        ForEach(CalendarView.watches, id: \.self) { device in
            GeometryReader { geometry in
                CalendarView(
                    today: Date(),
                    calendar: .makeCalendar(),
                    scheme: .standard
                )
                .font(.adjustedIWatchFont(screenHeight: geometry.size.height))
            }
            .preferredColorScheme(.light)
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)

        }
    }
}

private extension CalendarView {
    static let watches = [
        "Apple Watch Series 3 - 38mm",
        "Apple Watch Series 3 - 42mm",
        "Apple Watch Series 6 - 40mm",
        "Apple Watch Series 6 - 44mm",
    ]
}
