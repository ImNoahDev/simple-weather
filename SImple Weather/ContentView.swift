// ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var city = ""
    @State private var weatherData: WeatherData?
    @State private var showingAlert = false
    @State private var alertMessage = ""

    private let weatherService = WeatherService()

    var body: some View {
        VStack {
            TextField("Enter city name", text: $city, onCommit: fetchWeather)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let weatherData = weatherData {
                Text("City: \(weatherData.name)")
                    .font(.title)

                Text("Temperature: \(weatherData.main.temp, specifier: "%.1f") °C")
                Text("Humidity: \(weatherData.main.humidity, specifier: "%.1f") %")

                Text("Weather: \(weatherData.weather.first?.description ?? "")")
                    .padding()
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func fetchWeather() {
        weatherService.fetchWeather(city: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherData):
                    self.weatherData = weatherData
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
