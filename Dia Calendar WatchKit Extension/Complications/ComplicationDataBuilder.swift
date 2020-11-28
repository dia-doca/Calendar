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

    var timelineEndDate: Date? { .distantFuture }

    private let emphasisColor: UIColor = .orange

    private let calendar: Calendar

    init(calendar: Calendar) {
        self.calendar = calendar
    }

    func createComplicationDescriptors() -> [CLKComplicationDescriptor] {
        let supportedFamilies: [CLKComplicationFamily] = [.circularSmall, .modularSmall]
        return [
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .month),
                displayName: "Month & Date",
                supportedFamilies: supportedFamilies
            ),
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .weekday),
                displayName: "Weekday & Date",
                supportedFamilies: supportedFamilies
            ),
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .day),
                displayName: "Today's Date",
                supportedFamilies: supportedFamilies
            ),
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .weekProgress),
                displayName: "Progress",
                supportedFamilies: supportedFamilies
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
        case .modularSmall:
            return createModularSmallTemplate(forDate: date, withIdentifier: identifier)
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

    private func createModularSmallTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis?) -> CLKComplicationTemplate? {
        switch identifier {
        case .weekday:
            let template = CLKComplicationTemplateModularSmallStackText(
                line1TextProvider: .weekday(date),
                line2TextProvider: .day(date)
            )
            template.tintColor = emphasisColor
            return template
        case .month:
            let template = CLKComplicationTemplateModularSmallStackText(
                line1TextProvider: .month(date),
                line2TextProvider: .day(date)
            )
            template.tintColor = emphasisColor
            return template
        case .day:
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: .day(date))
        case .weekProgress:
            let fraction = weekFraction(date: date)
            let dayTextProvider: CLKDateTextProvider = .day(date)
            dayTextProvider.tintColor = .white
            let template = CLKComplicationTemplateModularSmallRingText(
                textProvider: dayTextProvider,
                fillFraction: fraction,
                ringStyle: .open
            )
            template.tintColor = weekColor(fraction: fraction)
            return template
        case .none:
            return nil
        }
    }

    private func createCircularSmallTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis?) -> CLKComplicationTemplate? {
        switch identifier {
        case .weekday:
            return CLKComplicationTemplateCircularSmallStackText(
                line1TextProvider: .weekday(date),
                line2TextProvider: .day(date)
            )
        case .month:
            return CLKComplicationTemplateCircularSmallStackText(
                line1TextProvider: .month(date),
                line2TextProvider: .day(date)
            )
        case .weekProgress:
            let fraction = weekFraction(date: date)
            let template = CLKComplicationTemplateCircularSmallRingText(
                textProvider: .day(date),
                fillFraction: fraction,
                ringStyle: .closed
            )
            template.tintColor = weekColor(fraction: fraction)
            return template
        case .day:
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: .day(date))
        case .none:
            return nil
        }
    }

    private func weekFraction(date: Date) -> Float {
        let weekday = calendar.component(.weekday, from: date)
        let weekdaysCount = calendar.weekdaySymbols.count
        let dayOfWeek = ( weekday + weekdaysCount - (calendar.firstWeekday - 1)) % weekdaysCount
        let progress = Float(dayOfWeek > 0 ? dayOfWeek : weekdaysCount) / Float(weekdaysCount)
        return progress
    }

    private func weekColor(fraction: Float) -> UIColor {
        let beginning: Float = 2/7
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

private extension CLKTextProvider {

    static func day(_ date: Date) -> CLKDateTextProvider {
        CLKDateTextProvider(date: date, units: .day)
    }

    static func weekday(_ date: Date) -> CLKDateTextProvider {
        CLKDateTextProvider(date: date, units: .weekday)
    }

    static func month(_ date: Date) -> CLKDateTextProvider {
        CLKDateTextProvider(date: date, units: .month)
    }

}
