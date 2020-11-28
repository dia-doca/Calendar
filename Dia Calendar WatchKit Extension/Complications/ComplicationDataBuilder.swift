//
//  ComplicationDataBuilder.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 27.11.2020.
//

import ClockKit


private enum ComplicationEmphasis: String {
    case weekday
    case month
    case day
    case weekProgress
}

final class ComplicationDataBuilder {

    private let calendar: Calendar

    var timelineEndDate: Date? { .distantFuture }

    init(calendar: Calendar) {
        self.calendar = calendar
    }

    func createComplicationDescriptors() -> [CLKComplicationDescriptor] {
        [
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .month),
                displayName: "Month & Date",
                supportedFamilies: [.circularSmall]
            ),
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .weekday),
                displayName: "Weekday & Date",
                supportedFamilies: [.circularSmall]
            ),
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .day),
                displayName: "Today's Date",
                supportedFamilies: [.circularSmall]
            ),
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .weekProgress),
                displayName: "Progress",
                supportedFamilies: [.circularSmall]
            ),
        ]
    }

    func createTimelineEntry(forComplication complication: CLKComplication, date: Date) -> CLKComplicationTimelineEntry? {
        createTemplate(forComplication: complication, date: date).map {
            CLKComplicationTimelineEntry(
                date: date,
                complicationTemplate: $0,
                timelineAnimationGroup: nil
            )
        }
    }

    func createTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int) -> [CLKComplicationTimelineEntry]? {
        let twentyFourHours = 24.0 * 60.0 * 60.0

        var current = calendar.startOfDay(for: date).addingTimeInterval(twentyFourHours)
        var entries = [CLKComplicationTimelineEntry]()

        while entries.count < limit, let timelineEntity = createTimelineEntry(forComplication: complication, date: current) {
            entries.append(timelineEntity)
            current = current.addingTimeInterval(twentyFourHours)
        }

        return entries
    }

    func createTemplate(forComplication complication: CLKComplication, date: Date) -> CLKComplicationTemplate? {
        let identifier = ComplicationEmphasis(rawValue: complication.identifier)
        switch complication.family {
//        case .modularSmall:
//            return createModularSmallTemplate(forDate: date)
//        case .modularLarge:
//            return createModularLargeTemplate(forDate: date)
//        case .utilitarianSmall, .utilitarianSmallFlat:
//            return createUtilitarianSmallFlatTemplate(forDate: date)
//        case .utilitarianLarge:
//            return createUtilitarianLargeTemplate(forDate: date)
        case .circularSmall:
            return createCircularSmallTemplate(forDate: date, withIdentifier: identifier)
//        case .extraLarge:
//            return createExtraLargeTemplate(forDate: date)
//        case .graphicCorner:
//            return createGraphicCornerTemplate(forDate: date)
//        case .graphicCircular:
//            return createGraphicCircleTemplate(forDate: date)
//        case .graphicRectangular:
//            return createGraphicRectangularTemplate(forDate: date)
//        case .graphicBezel:
//            return createGraphicBezelTemplate(forDate: date)
//        case .graphicExtraLarge:
//            return createGraphicExtraLargeTemplate(forDate: date)
        @unknown default:
            return nil
        }
    }

    // MARK: - Private

    private func createIdentifier(withEmphasis emphasis: ComplicationEmphasis) -> String {
        emphasis.rawValue
    }

    private func createCircularSmallTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis?) -> CLKComplicationTemplate? {
        var template: CLKComplicationTemplate?
        switch identifier {
        case .weekday:
            template = CLKComplicationTemplateCircularSmallStackText(
                line1TextProvider: CLKDateTextProvider(date: date, units: .weekday),
                line2TextProvider: CLKDateTextProvider(date: date, units: .day)
            )
        case .month:
            template = CLKComplicationTemplateCircularSmallStackText(
                line1TextProvider: CLKDateTextProvider(date: date, units: .month),
                line2TextProvider: CLKDateTextProvider(date: date, units: .day)
            )
        case .weekProgress:
            let fraction = weekFraction(date: date)
            template = CLKComplicationTemplateCircularSmallRingText(
                textProvider: CLKDateTextProvider(date: date, units: .day),
                fillFraction: fraction,
                ringStyle: .closed
            )
            template?.tintColor = weekColor(fraction: fraction)
        case .day:
            template = CLKComplicationTemplateCircularSmallSimpleText(
                textProvider: CLKDateTextProvider(date: date, units: .day)
            )
        case .none:
            break
        }
        return template
    }

    private func weekFraction(date: Date) -> Float {
        let weekday = calendar.component(.weekday, from: date)
        let weekdaysCount = calendar.weekdaySymbols.count
        let dayOfWeek = ( weekday + weekdaysCount - (calendar.firstWeekday - 1)) % weekdaysCount
        let progress = Float(dayOfWeek > 0 ? dayOfWeek : weekdaysCount) / Float(weekdaysCount)
        return progress
    }

    private func weekColor(fraction: Float) -> UIColor {
        let beginning: Float = 1/7
        let ending: Float = 5/7
        switch fraction {
        case ...beginning:
            return .green
        case ...ending:
            return .yellow
        default:
            return .red
        }
    }

}
