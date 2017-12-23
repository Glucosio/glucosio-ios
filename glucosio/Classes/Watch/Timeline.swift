import Foundation

public class TimelineItem : NSObject /*, Equatable */ {
    public var timestamp : Date
    public var value: String
    public var unit: String
    public var desc : String

    public init(date: Date, value: String, unit: String, description: String) {
        timestamp = date
        self.value = value
        self.unit = unit
        desc = description
    }

    public override var description: String {
        return "TimelineItem: \(timestamp) \(value) \(unit) \(desc)"
    }

    // MARK: Equality
    static func == (lhs: TimelineItem, rhs: TimelineItem) -> Bool {
        return lhs.timestamp == rhs.timestamp &&
                lhs.value == rhs.value &&
                lhs.unit == rhs.unit &&
                lhs.description == rhs.description
    }

    // MARK: Dictionary (de)serialization

    convenience init(d: Dictionary<String, String>) {
        //TODO: how to use reflection here?
        self.init(date: Date(timeIntervalSince1970 : Double(d["timestamp"] ?? "") ?? 0.0),
                  value: d["value"] ?? "",
                  unit: d["unit"] ?? "",
                  description: d["desc"] ?? "")
    }

    public func toDictionary() -> Dictionary<String, String> {
        var d = Dictionary<String, String>.init()

        let mirror = Mirror(reflecting: self)
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            if(value is Date) {
                d[name] = String(describing: (value as! Date).timeIntervalSince1970)
            } else {
                d[name]=value as? String
            }
        }
        return d
    }

}

public class DayTimeline : NSObject /*, Equatable */ {
    public var elements : Array<TimelineItem>

    public init(items : Array<TimelineItem>) {
        elements = items

//        print(elements)
    }

    // MARK: UserDefaults (de)serialization

    public convenience override init() {
        self.init(UserDefaults.init())
    }

    public convenience init(_ def: UserDefaults) {
        self.init(def, key: "timeline")
    }

    public convenience init(_ def: UserDefaults, key: String) {
        self.init(d: def.dictionary(forKey: key) ?? Dictionary.init())
    }

    public func toUserDefaults(_ def : UserDefaults) {
        toUserDefaults(def, key: "timeline")
    }

    public func toUserDefaults(_ def : UserDefaults, key: String) {
        def.setValue(toDictionary(), forKey: key);
    }

    // MARK: Dictionary (de)serialization

    public convenience init(d: Dictionary<String, Any>) {
        if let rawElements = d["elements"] {
            let elements = (rawElements as! Array<Dictionary>).map { d in TimelineItem.init(d: d) }
            self.init(items: elements)
        } else {
            self.init(items: [])
        }
    }

    //d[elements] = Array[Dictionary<String,String>]
    public func toDictionary() -> Dictionary<String, Array<Dictionary<String, String>>> {
        var d = Dictionary<String, Array<Dictionary<String, String>>>.init()

        d["elements"] = elements.map { t in t.toDictionary() }

        return d
    }
}
