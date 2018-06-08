import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let min = DayTimeline.init().elements
            .min {a, b in a.timestamp.compare(b.timestamp) == ComparisonResult.orderedAscending}

        handler(min?.timestamp)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let max = DayTimeline.init().elements
            .max {a, b in a.timestamp.compare(b.timestamp) == ComparisonResult.orderedAscending}

        handler(max?.timestamp)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func template(family: CLKComplicationFamily, withReading reading: String, withUnit unit: String, desc: String) -> CLKComplicationTemplate? {
        switch(family) {
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()

            template.headerTextProvider = CLKSimpleTextProvider(text: reading + " " + unit)
            template.body1TextProvider = CLKSimpleTextProvider(text: desc)

            return template
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallStackText()

            template.line1TextProvider = CLKSimpleTextProvider(text: reading)
            template.line2TextProvider = CLKSimpleTextProvider(text: unit)

            return template
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()

            template.textProvider = CLKSimpleTextProvider(text: reading)

            return template;
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()

            template.textProvider = CLKSimpleTextProvider(text: reading)

            return template;
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()

            template.textProvider = CLKSimpleTextProvider(text: reading)

            return template
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallSimpleText()

            template.textProvider = CLKSimpleTextProvider(text: reading)

            return template
        default:
            return Optional.none
        }
    }

    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry

        let item = DayTimeline.init().elements.last

        let reading = item?.value ?? "N/A"
        let unit = item?.unit ?? ""
        let desc = item?.desc ?? ""

        if let template = template(family: complication.family, withReading: reading, withUnit: unit, desc: desc) {
            template.tintColor = UIColor.glucosio_pink()
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        }else {
            handler(nil)
        }
    }

    func filterTimelineEntries(for complication: CLKComplication, with filter: (TimelineItem) -> Bool) -> [CLKComplicationTimelineEntry]{

        let entries = DayTimeline.init().elements
            .filter(filter)
            .map({item -> CLKComplicationTimelineEntry? in
                if let template = template(family: complication.family, withReading: item.value, withUnit: item.unit, desc: item.desc) {
                    return CLKComplicationTimelineEntry(date: item.timestamp, complicationTemplate: template)
                } else {
                    return nil
                }
            })
            .compactMap {$0}

        return entries
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {

        //TODO: EMI: respect limit
        let entries = filterTimelineEntries(for: complication, with: {date.compare($0.timestamp) == ComparisonResult.orderedDescending })

        // Call the handler with the timeline entries prior to the given date
        handler(entries)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {

        //TODO: EMI: respect limit
        let entries = filterTimelineEntries(for: complication, with: {date.compare($0.timestamp) == ComparisonResult.orderedAscending })

        // Call the handler with the timeline entries after to the given date
        handler(entries)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
}
