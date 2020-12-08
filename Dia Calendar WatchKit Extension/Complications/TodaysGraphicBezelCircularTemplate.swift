//
//  TodaysGraphicBezelCircularTemplate.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 08.12.2020.
//

import SwiftUI
import ClockKit


struct TodaysGraphicBezelCircularTemplate: View {

    let date: Date

    var body: some View {
        VStack(spacing: -6) {
            Text(date.string(for: .weekdayShort).uppercased())
                .foregroundColor(.red)
                .font(.system(size: 12))
                .complicationForeground()
            Text(date.string(for: .day))
                .font(.system(size: 24))
        }

    }

}

struct TodaysGraphicBezelCircularTemplate_Preview: PreviewProvider {

    static var previews: some View {

        CLKComplicationTemplateGraphicCircularView(
            TodaysGraphicBezelCircularTemplate(date: Date())
        )
        .previewContext()

        CLKComplicationTemplateGraphicCircularView(
            TodaysGraphicBezelCircularTemplate(date: Date())
        )
        .previewContext(faceColor: .yellow)

    }
}
