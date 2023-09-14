import CoreLocation
import SwiftUI
import SwiftUIPager

class ViewModel: ObservableObject {
    private var locationManager: LocationManager
    @Published public var page: Page = .first()
    @Published public var pageItems: Array<QualityModel> = [QualityModel(location: CLLocation()), QualityModel(last: true)]
    init() {
        locationManager = LocationManager()
    }
}
