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

    @State private var dragGestureOffset: CGFloat = 0

    @State private var upperOffset: CGFloat = 0
    @State private var lowerOffset: CGFloat = 0

    @State private var upperMonth: Int = -1
    @State private var lowerMonth: Int = 0

    @State private var geometryHeight: CGFloat = 340

    @State private var activeViewSwitcher: Bool = true

    @State private var direction: Int = 0

    private let pagesOffset: CGFloat = 16

    var drag: some Gesture {
        DragGesture(minimumDistance: .zero, coordinateSpace: .global)
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
                calendar(monthsOffset: upperMonth, positionOffset: upperOffset)
                calendar(monthsOffset: lowerMonth, positionOffset: lowerOffset)
            }
            .gesture(drag)
            .onAppear(perform: {
                geometryHeight = geometry.size.height
                upperOffset = -(geometryHeight + pagesOffset)
            })
        }
    }

    private func calendar(monthsOffset offset: Int, positionOffset: CGFloat) -> some View {
        CalendarView(
            today: today,
            month: calendar.date(byAdding: DateComponents(month: offset), to: today)!,
            calendar: calendar,
            scheme: scheme
        )
        .scaleEffect( 1 - CGFloat( abs(positionOffset + dragGestureOffset) / (8 * geometryHeight)).bounded(in: 0...1) )
        .offset(y: positionOffset + dragGestureOffset)
        .opacity( 1 - Double( abs(positionOffset + dragGestureOffset) / geometryHeight).bounded(in: 0...1) )
    }

}

extension Comparable {
    func bounded(in range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound {
            return range.lowerBound
        } else if self > range.upperBound {
            return range.upperBound
        } else {
            return self
        }
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
