// WeatherData.swift

import Foundation

struct WeatherData: Codable {
    let main: Weather
    let weather: [WeatherDescription]
    let name: String
}

struct Weather: Codable {
    let temp: Double
    let humidity: Double
}

struct WeatherDescription: Codable {
    let description: String
    let id: Int
}
