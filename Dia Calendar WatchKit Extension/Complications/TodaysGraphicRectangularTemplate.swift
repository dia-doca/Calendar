//
//  TodaysGraphicRectangularTemplate.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 03.12.2020.
//

import SwiftUI
import ClockKit

struct TodaysGraphicRectangularTemplate: View {

    let date: Date
    let primaryColor: Color
    let secondaryColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(date.string(for: .month))
                .foregroundColor(primaryColor)
                .font(.caption)
                .complicationForeground()
            HStack {
                Text(date.string(for: .weekdayAndDay))
                    .foregroundColor(secondaryColor)
                    .font(.title)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                Spacer()
            }
        }
    }

}

struct TodaysGraphicRectangularTemplate_Preview: PreviewProvider {

    static var previews: some View {

        CLKComplicationTemplateGraphicRectangularFullView(
            TodaysGraphicRectangularTemplate(date: Date(), primaryColor: .red, secondaryColor: .secondary)
        )
        .previewContext()

        CLKComplicationTemplateGraphicRectangularFullView(
            TodaysGraphicRectangularTemplate(date: Date(), primaryColor: .red, secondaryColor: .secondary)
        )
        .previewContext(faceColor: .yellow)

    }
}
