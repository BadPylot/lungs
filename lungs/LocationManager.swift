import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    public var curLoc: CLLocation? = nil
    private var changedHandler: (() -> Void)? = nil
    private var locationManager:CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    public func setChangedHandler(changedHandler: @escaping () -> Void) {
        self.changedHandler = changedHandler
    }
    // Delegates
    func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]) {
        if (didUpdateLocations.first != nil) {
            let oldLoc = curLoc
            curLoc = didUpdateLocations.first!
            // If the user has moved less than 50 feet (converted to meters for comparison)
            if ((oldLoc == nil) || oldLoc!.distance(from: curLoc!) > (50 * 0.3048)) {
                if (changedHandler != nil) {
                    changedHandler!()
                }
            }
        }
    }
    func locationManagerDidChangeAuthorization(_: CLLocationManager) {
        if (locationManager.authorizationStatus == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        } else if (locationManager.authorizationStatus == .authorizedWhenInUse){
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }
    func locationManager(_: CLLocationManager, didFailWithError: Error) {
        // If this doesn't exist the app crashes
    }
}
