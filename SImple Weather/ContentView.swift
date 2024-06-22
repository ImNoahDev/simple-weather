import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var weatherService = WeatherService()
    @State private var searchText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter city name", text: $searchText, onCommit: {
                    weatherService.fetchWeather(for: searchText)
                    hideKeyboard()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                
                if let weatherData = weatherService.weatherData {
                    WeatherView(weatherData: weatherData)
                } else {
                    ProgressView("Fetching Weather...")
                        .padding()
                }
                
                Spacer()
            }
            .navigationBarTitle("Weather")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            weatherService.startLocationUpdates()
        }
        .onDisappear {
            weatherService.stopLocationUpdates()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WeatherView: View {
    let weatherData: WeatherData
    
    var body: some View {
        VStack {
            Text("\(weatherData.name)")
                .font(.title)
                .padding()
            
            Text("\(weatherData.main.temp, specifier: "%.1f") °C")
                .font(.title2)
            
            Text("Humidity: \(weatherData.main.humidity, specifier: "%.1f") %")
                .font(.headline)
            
            Text("\(weatherData.weather.first?.description ?? "")")
                .font(.headline)
                .padding()
            
            Spacer()
        }
        .padding()
    }
}
