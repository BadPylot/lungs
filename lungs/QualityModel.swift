import CoreLocation

// API Key, loaded from Config.plist API_KEY key.
// Stolen from ChatGPT, I know how it works but didn't write it myself
var apiKey: String {
    if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
       let key = dict["API_KEY"] as? String {
        return key
    } else {
        fatalError("API key not found in Config.plist")
    }
}

public class QualityModel: Equatable, Hashable, ObservableObject {
    public let last: Bool
    public let location: CLLocation?
    init(location: CLLocation?) {
        last = false
        self.location = location
    }
    init (last: Bool) {
        self.last = last
        location = CLLocation()
    }
    public func refresh(newLocation: CLLocation?) {
        
    }
    // Not tested as of this commit
    private func updateData() async {
        if (location == nil) {
            return
        }
        let url = URL(string: "http://api.airvisual.com/v2/nearest_city?lat=\(location!.coordinate.latitude)&lon=\(location!.coordinate.longitude)&key=\(apiKey)")!
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    // Protocol functions, necessary for SwiftUIPager
    public static func == (lhs: QualityModel, rhs: QualityModel) -> Bool {
        return (lhs.location === rhs.location) && (lhs.last == rhs.last)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(last)
        hasher.combine(location)
    }
}
