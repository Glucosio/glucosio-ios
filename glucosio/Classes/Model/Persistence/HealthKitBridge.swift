import Foundation
import HealthKit
import UIKit


public class HealthKitBridge : NSObject {
    let store = HKHealthStore()

    @objc public static let singleton = HealthKitBridge()

     /*!
     Save a single mg/dL measurement
     */
    @objc public func addMolarMassBloodGlucose(value: Double, when: Date, mealTime: String) {
        if(HKHealthStore.isHealthDataAvailable()) {
            let glucoseType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)
            let quantity = HKQuantity(unit: HKUnit(from: "mg/dL"), doubleValue: value)

            let authStatus = store.authorizationStatus(for: glucoseType!)
            var allowStore = (authStatus == .sharingAuthorized)
            
            if (authStatus == .notDetermined) {
                store.requestAuthorization(toShare: [glucoseType!], read: [], completion: { (success, error) in
                    allowStore = success
                })
            }
            if (allowStore) {
                let iosVersion = (UIDevice.current.systemVersion as NSString).floatValue
                var hkMealtimeKey = "HKBloodGlucoseMealTime"
                if iosVersion >= 11.0 {
                    hkMealtimeKey = "HKMetadataKeyBloodGlucoseMealTime"
                }
                let metadata = [hkMealtimeKey: mealTime]
                let measurement = HKQuantitySample(type: glucoseType!, quantity: quantity,
                                                   start: when, end: when,
                                                   metadata: metadata)
                self.store.save(measurement, withCompletion: { (saved, err) in
                    if(!saved) {
                        print(err ?? "Error during save to HealthKit")
                    }
                })
            } else {
                print("Error during save to HealthKit, no authorization granted")
            }

        }
    }
}
