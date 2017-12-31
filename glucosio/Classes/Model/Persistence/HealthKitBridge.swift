import Foundation
import HealthKit


public class HealthKitBridge : NSObject {
    let store = HKHealthStore()

    public static let singleton = HealthKitBridge()

     /*!
     Save a single mg/dL measurement
     */
    public func addMolarMassBloodGlucose(value: Double, when: Date, mealTime: String) {
        if(HKHealthStore.isHealthDataAvailable()) {
            let glucoseType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)
            let quantity = HKQuantity(unit: HKUnit(from: "mg/dL"), doubleValue: value)

            store.requestAuthorization(toShare: [glucoseType!], read: [], completion: { (success, error) in
                if(success) {
                    //HKMetadataKeyBloodGlucoseMealTime shows up in iOS 11.0+, using a hardcoded string bellow
                    let metadata = ["HKBloodGlucoseMealTime": mealTime]
                    let measurement = HKQuantitySample(type: glucoseType!, quantity: quantity,
                                                       start: when, end: when,
                                                       metadata: metadata)
                    self.store.save(measurement, withCompletion: { (saved, err) in
                        if(!saved) {
                            print(err)
                        }
                    })
                } else {
                    print(error)
                }
            })
        }
    }
}
