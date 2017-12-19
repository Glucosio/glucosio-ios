import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
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

        let def = UserDefaults.init()

        let reading = def.string(forKey: "reading") ?? "N/A"
        let unit = def.string(forKey: "unit") ?? ""
        let desc = def.string(forKey: "desc") ?? ""

        if let template = template(family: complication.family, withReading: reading, withUnit: unit, desc: desc) {
            template.tintColor = UIColor.glucosio_pink()
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        }else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
}
