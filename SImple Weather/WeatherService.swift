import Foundation
import CoreLocation

class WeatherService: NSObject, ObservableObject {
    @Published var weatherData: WeatherData?
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchWeather(for city: String) {
        guard let apiKey = apiKey else {
            print("API key not found")
            return
        }
        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric"
        fetchWeather(from: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        guard let apiKey = apiKey else {
            print("API key not found")
            return
        }
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        fetchWeather(from: urlString)
    }
    
    private func fetchWeather(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching weather data:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("Data not available")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.weatherData = decodedResponse
                }
            } catch {
                print("Error decoding weather data:", error.localizedDescription)
            }
        }.resume()
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
}

extension WeatherService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            stopLocationUpdates()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error:", error.localizedDescription)
    }
}
