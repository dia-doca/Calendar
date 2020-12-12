//
//  AnimatedCalendarPagerView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 12.12.2020.
//

import SwiftUI


struct AnimatedCalendarPagerView: View {

    let today: Date
    let calendar: Calendar
    let scheme: CalendarScheme

    @State private var monthOffset: Int = 0

    @State private var animatedPaginationFlag = false

    @State private var isForwardDirection = true

    @State private var didPageChange = false

    var paginationGesture: some Gesture {
        DragGesture(minimumDistance: .zero, coordinateSpace: .global)
            .onChanged { value in
                guard abs(value.translation.height) > 10, didPageChange == false else { return }
                isForwardDirection = value.translation.height > 0
                animatedPaginationFlag.toggle()
                monthOffset += isForwardDirection ? -1 : 1
                didPageChange = true
            }
            .onEnded { value in
                didPageChange = false
            }
    }

    var todaysGesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                monthOffset = 0
            }
    }

    var combinedGesture: some Gesture {
        paginationGesture.simultaneously(with: todaysGesture)
    }

    var body: some View {
        VStack {
            if animatedPaginationFlag {
                calendarView(monthOffset: monthOffset)
                    .transition(
                        .asymmetric(insertion: .move(edge: isForwardDirection ? .top : .bottom), removal: .move(edge: isForwardDirection ? .bottom : .top))
                    )
                    .animation(.easeOut)
            } else {
                calendarView(monthOffset: monthOffset)
                    .transition(
                        .asymmetric(insertion: .move(edge: isForwardDirection ? .top : .bottom), removal: .move(edge: isForwardDirection ? .bottom : .top))
                    )
                    .animation(.easeOut)
            }
        }
        .gesture(combinedGesture)
    }

    private func calendarView(monthOffset: Int) -> some View {
        CalendarView(
            today: today,
            month: calendar.date(byAdding: DateComponents(month: monthOffset), to: today)!,
            calendar: calendar,
            scheme: scheme
        )
    }

}


struct AnimatedCalendarPagerView_Preview: PreviewProvider {

    static var previews: some View {

        ForEach(PreviewDevices.watches, id: \.self) { device in
            AnimatedCalendarPagerView(today: Date(), calendar: .makeCalendar(), scheme: .standard)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }

    }

}
