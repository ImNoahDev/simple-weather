import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let coord: Coord
    let wind: Wind
    let visibility: Int
    let clouds: Clouds
    let sys: Sys
    
    struct Coord: Codable {
        let lat: Double
        let lon: Double
    }
    
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let pressure: Double
        let humidity: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case pressure
            case humidity
        }
    }
    
    struct Weather: Codable {
        let description: String
    }
    
    struct Wind: Codable {
        let speed: Double
        
        enum CodingKeys: String, CodingKey {
            case speed
        }
    }
    
    struct Clouds: Codable {
        let all: Int
        
        enum CodingKeys: String, CodingKey {
            case all
        }
    }
    
    struct Sys: Codable {
        let sunrise: Int
        let sunset: Int
        
        enum CodingKeys: String, CodingKey {
            case sunrise
            case sunset
        }
    }
}
