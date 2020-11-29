//
//  ComplicationDataBuilder.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 27.11.2020.
//

import ClockKit


private enum ComplicationEmphasis: String {
    case month
    case weekday
    case day
    case weekProgress
}

final class ComplicationDataBuilder {

    var timelineEndDate: Date? { .distantFuture }

    private let emphasisRedColor: UIColor = .init(red: 0.9, green: 0.1, blue: 0.1, alpha: 1)
    private let emphasisOrangeColor: UIColor = .orange

    private let calendar: Calendar

    init(calendar: Calendar) {
        self.calendar = calendar
    }

    func createComplicationDescriptors() -> [CLKComplicationDescriptor] {
        let smallFamilies: [CLKComplicationFamily] = [.circularSmall, .modularSmall, .utilitarianSmall]
        let largeFamilies: [CLKComplicationFamily] = [.extraLarge, .modularLarge, .utilitarianLarge]
        return [
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .day),
                displayName: "Today's Date",
                supportedFamilies: smallFamilies + largeFamilies + [.graphicCorner, .graphicCircular]
            ),
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .weekday),
                displayName: "Weekday & Date",
                supportedFamilies: smallFamilies + [.utilitarianLarge] + [.graphicCorner, .graphicCircular]
            ),
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .month),
                displayName: "Month & Date",
                supportedFamilies: smallFamilies + [.utilitarianLarge] + [.graphicCorner, .graphicCircular]
            ),
            CLKComplicationDescriptor(
                identifier: createIdentifier(withEmphasis: .weekProgress),
                displayName: "Today's Date",
                supportedFamilies: smallFamilies + [.graphicCorner]
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
        guard let identifier: ComplicationEmphasis = complication.identifier == CLKDefaultComplicationIdentifier
            ? .day
            : ComplicationEmphasis(rawValue: complication.identifier)
        else {
            return nil
        }
        switch complication.family {
        case .modularSmall:
            return createModularSmallTemplate(forDate: date, withIdentifier: identifier)
        case .modularLarge:
            return createModularLargeTemplate(forDate: date, withIdentifier: identifier)
        case .utilitarianSmall, .utilitarianSmallFlat:
            return createUtilitarianSmallFlatTemplate(forDate: date, withIdentifier: identifier)
        case .utilitarianLarge:
            return createUtilitarianLargeTemplate(forDate: date, withIdentifier: identifier)
        case .circularSmall:
            return createCircularSmallTemplate(forDate: date, withIdentifier: identifier)
        case .extraLarge:
            return createExtraLargeTemplate(forDate: date, withIdentifier: identifier)
        case .graphicCorner:
            return createGraphicCornerTemplate(forDate: date, withIdentifier: identifier)
        case .graphicCircular:
            return createGraphicCircleTemplate(forDate: date, withIdentifier: identifier)
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

    private func createModularLargeTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis) -> CLKComplicationTemplate? {
        CLKComplicationTemplateModularLargeTallBody(
            headerTextProvider: .month(date, tintColor: emphasisRedColor),
            bodyTextProvider: .dayWeekday(date)
        )
    }

    /// hint: can play with colors
    private func createModularSmallTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis) -> CLKComplicationTemplate? {
        switch identifier {
        case .month:
            let template = CLKComplicationTemplateModularSmallStackText(
                line1TextProvider: .month(date, uppercased: true),
                line2TextProvider: .day(date)
            )
            template.tintColor = emphasisRedColor
            return template
        case .weekday:
            let template = CLKComplicationTemplateModularSmallStackText(
                line1TextProvider: .weekday(date, uppercased: true),
                line2TextProvider: .day(date)
            )
            template.tintColor = emphasisRedColor
            return template
        case .day:
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: .day(date))
        case .weekProgress:
            let fraction = weekFraction(date: date)
            let template = CLKComplicationTemplateModularSmallRingText(
                textProvider: .day(date, tintColor: .white),
                fillFraction: fraction,
                ringStyle: .open
            )
            template.tintColor = weekColor(fraction: fraction)
            return template
        }
    }

    /// hint: has no colors
    private func createUtilitarianSmallFlatTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis) -> CLKComplicationTemplate? {
        switch identifier {
        case .month:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKDateTextProvider(date: date, units: [.day, .month]))
        case .weekday:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKDateTextProvider(date: date, units: [.day, .weekday]))
        case .day:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: .day(date))
        case .weekProgress:
            return CLKComplicationTemplateUtilitarianSmallRingText(
                textProvider: .day(date),
                fillFraction: weekFraction(date: date),
                ringStyle: .open
            )
        }
    }

    private func createUtilitarianLargeTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis) -> CLKComplicationTemplate? {
        switch identifier {
        case .month:
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKDateTextProvider(date: date, units: [.day, .month]))
        case .weekday:
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKDateTextProvider(date: date, units: [.day, .weekday]))
        case .day:
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKDateTextProvider(date: date, units: [.day, .weekday, .month]))
        case .weekProgress:
            return nil
        }
    }

    /// hint: uses watch face plain color. you can change progress ring tint color
    private func createCircularSmallTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis) -> CLKComplicationTemplate? {
        switch identifier {
        case .month:
            return CLKComplicationTemplateCircularSmallStackText(
                line1TextProvider: .month(date),
                line2TextProvider: .day(date)
            )
        case .weekday:
            return CLKComplicationTemplateCircularSmallStackText(
                line1TextProvider: .weekday(date),
                line2TextProvider: .day(date)
            )
        case .day:
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: .day(date))
        case .weekProgress:
            let fraction = weekFraction(date: date)
            let template = CLKComplicationTemplateCircularSmallRingText(
                textProvider: .day(date),
                fillFraction: fraction,
                ringStyle: .closed
            )
            template.tintColor = weekColor(fraction: fraction)
            return template
        }
    }

    private func createExtraLargeTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis) -> CLKComplicationTemplate? {
        CLKComplicationTemplateExtraLargeSimpleText(textProvider: .day(date))
    }

    private func createGraphicCornerTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis) -> CLKComplicationTemplate? {
        switch identifier {
        case .month:
            return CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: .month(date, tintColor: emphasisOrangeColor),
                outerTextProvider: .day(date)
            )
        case .weekday:
            return CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: .weekday(date, tintColor: emphasisOrangeColor),
                outerTextProvider: .day(date)
            )
        case .day:
            return CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: .month(date, tintColor: emphasisOrangeColor),
                outerTextProvider: CLKDateTextProvider(date: date, units: [.day, .weekday])
            )
        case .weekProgress:
            let fraction = weekFraction(date: date)
            let color = weekColor(fraction: fraction)
            return CLKComplicationTemplateGraphicCornerGaugeText(
                gaugeProvider: CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: fraction),
                outerTextProvider: CLKDateTextProvider(date: date, units: [.day, .weekday])
            )
        }
    }

    private func createGraphicCircleTemplate(forDate date: Date, withIdentifier identifier: ComplicationEmphasis) -> CLKComplicationTemplate? {
        switch identifier {
        case .month:
            return CLKComplicationTemplateGraphicCircularStackText(
                line1TextProvider: .month(date, tintColor: emphasisOrangeColor),
                line2TextProvider: .day(date)
            )
        case .weekday:
            return CLKComplicationTemplateGraphicCircularStackText(
                line1TextProvider: .weekday(date, tintColor: emphasisOrangeColor),
                line2TextProvider: .day(date)
            )
        case .day, .weekProgress:
            let fraction = weekFraction(date: date)
            let color = weekColor(fraction: fraction)
            return CLKComplicationTemplateGraphicCircularClosedGaugeText(
                gaugeProvider: CLKSimpleGaugeProvider(style: .ring, gaugeColor: color, fillFraction: fraction),
                centerTextProvider: .day(date)
            )
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

    static func day(_ date: Date, tintColor: UIColor? = nil) -> CLKDateTextProvider {
        createDateProvider(date: date, units: .day, tintColor: tintColor)
    }

    static func dayWeekday(_ date: Date, tintColor: UIColor? = nil) -> CLKDateTextProvider {
        createDateProvider(date: date, units: [.day, .weekday], tintColor: tintColor)
    }

    static func weekday(_ date: Date, tintColor: UIColor? = nil, uppercased: Bool? = nil) -> CLKDateTextProvider {
        createDateProvider(date: date, units: .weekday, tintColor: tintColor, uppercased: uppercased)
    }

    static func month(_ date: Date, tintColor: UIColor? = nil, uppercased: Bool? = nil) -> CLKDateTextProvider {
        createDateProvider(date: date, units: .month, tintColor: tintColor, uppercased: uppercased)
    }

    private static func createDateProvider(date: Date, units: NSCalendar.Unit, tintColor: UIColor? = nil, uppercased: Bool? = nil) -> CLKDateTextProvider {
        let provider = CLKDateTextProvider(date: date, units: units)
        uppercased.map { provider.uppercase = $0 }
        tintColor.map { provider.tintColor = $0 }
        return provider
    }

}
