import CoreLocation
import SwiftUI
import SwiftUIPager

class ViewModel: ObservableObject {
    private var locationManager: LocationManager
    @Published public var page: Page = .first()
    @Published public var pageItems: Array<QualityModel> = [];
    init() {
        locationManager = LocationManager()
        pageItems.append(QualityModel(location: locationManager.curLoc, first: true))
        pageItems.append(QualityModel(location: CLLocation(), first: false))
        locationManager.setChangedHandler(changedHandler: locationChanged)
    }
    init(demo:Bool) {
        locationManager = LocationManager()
        // Chapel Hill
        pageItems.append(QualityModel(location: CLLocation(latitude: 35.907850, longitude: -79.050289), first: true))
        // Wilmington
        pageItems.append(QualityModel(location: CLLocation(latitude: 34.210389, longitude: -77.886812), first: false))
    }
    
    private func locationChanged() {
        if (pageItems.isEmpty) {
            return
        }
        pageItems.first!.refresh(newLocation:locationManager.curLoc)
    }
}
