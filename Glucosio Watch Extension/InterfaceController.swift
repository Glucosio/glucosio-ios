import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var latestReading : WKInterfaceLabel!
    @IBOutlet var desc : WKInterfaceLabel!
    let KEY_UPDATEME = "updateme"

    let def = UserDefaults.init()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
        updateReading()
    }

    func updateReading() {
        var reading : String
        var unit : String
        var _desc : String

        if let item = DayTimeline.init(def).elements.last {
            reading = item.value
            unit = item.unit
            _desc = item.desc
        } else {
            reading = "N/A"
            unit = ""
            _desc = ""
        }

        latestReading.setText(reading)
        desc.setText(unit + " " + _desc)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        if WCSession.isSupported() {
            let session = WCSession.default()
            if (session.activationState == WCSessionActivationState.notActivated) {
                session.delegate = self
                session.activate()
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if (session.isReachable) {
            let message = [KEY_UPDATEME : ""]
            //TODO: reply to this message from iOS side
            session.sendMessage(message, replyHandler: nil)
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DayTimeline.init(d: applicationContext).toUserDefaults(def)

        for complication in CLKComplicationServer.sharedInstance().activeComplications! {
            CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
        }

        updateReading()
    }

}
