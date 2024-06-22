import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coord
    
    struct Coord: Codable {
        let lat: Double
        let lon: Double
    }
}

struct Main: Codable {
    let temp: Double
    let humidity: Double
}

struct Weather: Codable {
    let description: String
}
