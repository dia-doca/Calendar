//
//  CalendarView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 21.11.2020.
//

import SwiftUI


struct CalendarView: View {

    let today: Date
    let month: Date
    let calendar: Calendar
    let scheme: CalendarScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            CalendarHeaderView(calendar: calendar, today: today, month: month, scheme: scheme.header)
            CalendarBodyView(calendar: calendar, today: today, month: month, scheme: scheme.date)
        }
    }

}

struct CalendarView_Previews: PreviewProvider {

    static var previews: some View {
        let calendar = Calendar.makeCalendar()
        let today = Date()
        let month = calendar.date(byAdding: DateComponents(month: 0), to: today)!
        ForEach(PreviewDevices.watches, id: \.self) { device in
            GeometryReader { geometry in
                CalendarView(
                    today: today,
                    month: month,
                    calendar: calendar,
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
