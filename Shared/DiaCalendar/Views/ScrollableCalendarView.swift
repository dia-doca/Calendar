//
//  ScrollableCalendarView.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 11.12.2020.
//

import SwiftUI


struct ScrollableCalendarView: View {

    let today: Date
    let calendar: Calendar
    let scheme: CalendarScheme

    @State private var monthOffset: Int = 0

    @State private var dragGestureOffset: CGFloat = 0

    @State private var upperOffset: CGFloat = 0
    @State private var lowerOffset: CGFloat = 0

    @State private var upperMonth: Int = -1
    @State private var lowerMonth: Int = 0

    @State private var geometryHeight: CGFloat = 0

    @State private var activeViewSwitcher: Bool = true

    @State private var direction: Int = 0

    private let pagesOffset: CGFloat = 16

    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                dragGestureOffset = value.translation.height
                if dragGestureOffset > 0 {
                    direction = -1
                } else {
                    direction = 1
                }
                upperOffset = CGFloat(direction) * (activeViewSwitcher ? geometryHeight + pagesOffset : 0)
                lowerOffset = CGFloat(direction) * (activeViewSwitcher ? 0 : geometryHeight + pagesOffset)
                if activeViewSwitcher {
                    upperMonth = lowerMonth + direction
                } else {
                    lowerMonth = upperMonth + direction
                }
            }
            .onEnded { value in
                guard abs(value.predictedEndTranslation.height) > geometryHeight / 2 else {
                    withAnimation {
                        dragGestureOffset = 0
                    }
                    return
                }
                withAnimation {
                    dragGestureOffset = 0
                    upperOffset = CGFloat(-direction) * (activeViewSwitcher ? 0 : geometryHeight + pagesOffset)
                    lowerOffset = CGFloat(-direction) * (activeViewSwitcher ? geometryHeight + pagesOffset : 0)
                    activeViewSwitcher.toggle()
                }
            }
    }

    var body: some View {
        GeometryReader { geometry in
            Group {
                calendar(monthsOffset: upperMonth)
                    .offset(y: upperOffset + dragGestureOffset)
                calendar(monthsOffset: lowerMonth)
                    .offset(y: lowerOffset + dragGestureOffset)
            }
            .gesture(drag)
            .onAppear(perform: {
                geometryHeight = geometry.size.height
                upperOffset = -(geometryHeight + pagesOffset)
            })
        }
    }

    private func calendar(monthsOffset offset: Int) -> some View {
        CalendarView(
            today: today,
            month: calendar.date(byAdding: DateComponents(month: offset), to: today)!,
            calendar: calendar,
            scheme: scheme
        )
    }

}

struct ScrollableCalendarView_Preview: PreviewProvider {

    static var previews: some View {

        ForEach(PreviewDevices.watches, id: \.self) { device in
            ScrollableCalendarView(today: Date(), calendar: .makeCalendar(), scheme: .standard)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }

    }

}
