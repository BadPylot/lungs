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
    
    // Delegate functions
    func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]) {
        if (didUpdateLocations.first != nil) {
            let oldLoc = curLoc
            curLoc = didUpdateLocations.first!
            // If the user has moved more than 1km or there is no previous location
            if ((oldLoc == nil) || oldLoc!.distance(from: curLoc!) > (1000)) {
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
        // Required to exist
    }
}
