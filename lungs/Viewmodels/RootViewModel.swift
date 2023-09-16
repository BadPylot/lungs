import CoreLocation
import SwiftUI
import SwiftUIPager

class ViewModel: ObservableObject {
    private let locationManager: LocationManager = LocationManager()
    private let geocoder = CLGeocoder()
    @Published public var page: Page = .first()
    @Published public var pageItems: Array<QualityModel> = []
    @Published public var addLoc = false
    @Published public var searchText:String = ""
    @Published public var searchResults: Array<CLPlacemark> = []
    private var searchDebounce: Timer?
    private var locations: Array<CLLocation> = []
    
    init() {
        pageItems.append(QualityModel(location: locationManager.curLoc))
        locationManager.setChangedHandler(changedHandler: locationChanged)
        loadLocations()
    }
    
    init(demo: Bool) {
        pageItems.append(QualityModel())
    }
    
    public func handleSearchInput() {
        searchDebounce?.invalidate()
        searchDebounce = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            Task {
                let results = (try? await self.geocoder.geocodeAddressString(self.searchText)) ?? []
                await MainActor.run {
                    self.searchResults = results
                }
            }
        }
    }
    
    public func addPage(newLoc: CLLocation) -> Bool {
        locations.append(newLoc)
        pageItems.append(QualityModel(location: newLoc))
        pageItems.last?.refresh(newLocation: nil)
        saveLocations()
        return true
    }
    
    public func removePage(index: Int) {
        locations.remove(at: index - 1)
        pageItems.remove(at: index)
        saveLocations()
    }
    
    private func saveLocations() {
        let locationDictionaries = locations.map {
            return $0.toDictionary()
        }
        if let data = try? JSONSerialization.data(withJSONObject: locationDictionaries, options: []) {
            UserDefaults.standard.set(data, forKey: "locations")
        }
    }
    
    private func loadLocations() {
        if let data = UserDefaults.standard.data(forKey: "locations"),
           let decodedLocationDictionaries = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
            locations = decodedLocationDictionaries.compactMap {  CLLocation.fromDictionary($0) }
            pageItems[1...] = ArraySlice(locations.map { QualityModel(location: $0) })
        }
    }
    
    private func locationChanged() {
        if (pageItems.isEmpty) {
            return
        }
        pageItems.first!.refresh(newLocation:locationManager.curLoc)
    }
}

// CLLocation extensions to faciliate storage to and from UserDefaults
extension CLLocation {
    func toDictionary() -> [String: Any] {
        return [
            "latitude": self.coordinate.latitude,
            "longitude": self.coordinate.longitude,
        ]
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) -> CLLocation? {
        if let latitude = dictionary["latitude"] as? CLLocationDegrees,
           let longitude = dictionary["longitude"] as? CLLocationDegrees {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        return nil
    }
}
