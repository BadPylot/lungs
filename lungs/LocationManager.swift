import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published public var curLoc: CLLocation? = nil
    private var locationManager:CLLocationManager

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    // Delegates
    func locationManager(_: CLLocationManager, locations: [CLLocation]) {
        if (locations.first != nil) {
            curLoc = locations.first!
        }
    }
    func locationManagerDidChangeAuthorization(_: CLLocationManager) {
        if (locationManager.authorizationStatus == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        } else if (locationManager.authorizationStatus == .authorizedWhenInUse){
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_: CLLocationManager, didFailWithError: Error) {
        // If this doesn't exist the app crashes
    }
}
