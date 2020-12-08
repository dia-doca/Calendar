//
//  TodaysGraphicRectangularTemplate.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 03.12.2020.
//

import SwiftUI
import ClockKit

private extension Date {
    func string(forDateFormat dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}

private extension String {
    static let month = "MMMM"
    static let weekdayAndDay = "EEEE d"
}

struct TodaysGraphicRectangularTemplate: View {

    let date: Date
    let primaryColor: Color
    let secondaryColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(date.string(forDateFormat: .month))
                .foregroundColor(primaryColor)
                .font(.caption)
                .complicationForeground()
            HStack {
                Text(date.string(forDateFormat: .weekdayAndDay))
                    .foregroundColor(secondaryColor)
                    .font(.title)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                Spacer()
            }
        }
    }

}

struct Template_Preview: PreviewProvider {

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
