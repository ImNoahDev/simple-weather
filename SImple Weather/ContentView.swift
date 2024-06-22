import SwiftUI
struct ContentView: View {
    @StateObject private var weatherService = WeatherService()
    @State private var searchText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Background Map Image
                if let weatherData = weatherService.weatherData {
                    MapBackground(latitude: weatherData.coord.lat, longitude: weatherData.coord.lon)
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                } else {
                    Color.blue.edgesIgnoringSafeArea(.all)
                }

                VStack {
                    // Search Bar and UI Components
                    Spacer() // Push content to the bottom

                    HStack {
                        TextField("Enter city name", text: $searchText, onCommit: {
                            weatherService.fetchWeather(for: searchText)
                            hideKeyboard()
                        })
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10) // Rounded corners
                        .padding(.horizontal)
                        .frame(maxWidth: 330) // Limit width of search bar

                        Button(action: {
                            weatherService.fetchWeather(for: searchText)
                            hideKeyboard()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing)
                    }
                    .padding()

                    if let weatherData = weatherService.weatherData {
                        WeatherView(weatherData: weatherData)
                            .transition(.slide)
                            .padding()
                    } else {
                        ProgressView("Fetching Weather...")
                            .padding()
                    }
                }
                .navigationBarHidden(true) // Hide navigation bar

                // Alert for error message
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
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
            Text("Good morning, ")
                .italic()
                .padding(.top)
                .fontWeight(.bold)
                .font(.system(size: 28))
            
            Text(weatherData.name)
                .fontWeight(.bold)
                .font(.system(size: 48))
            
            Text("\(weatherData.main.temp, specifier: "%.1f") °C")
                .font(.system(size: 64))
                .fontWeight(.light)
                .padding(.top)
            
            HStack {
                Image(systemName: "thermometer")
                    .foregroundColor(.red)
                Text("Feels like: \(weatherData.main.feelsLike, specifier: "%.1f") °C")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.top)
            
            HStack {
                Image(systemName: "wind")
                    .foregroundColor(.green)
                Text("Wind: \(weatherData.wind.speed, specifier: "%.1f") m/s")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.top)
            
            HStack {
                Image(systemName: "gauge")
                    .foregroundColor(.purple)
                Text("Pressure: \(weatherData.main.pressure, specifier: "%.0f") hPa")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.top)
            
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundColor(.blue)
                Text("Humidity: \(weatherData.main.humidity, specifier: "%.0f")%")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.top)
            
            HStack {
                Image(systemName: weatherIcon(for: weatherData.weather.first?.description ?? "Clear"))
                    .foregroundColor(.yellow)
                Text(weatherData.weather.first?.description.capitalized ?? "")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding()

            Spacer()
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .opacity(0.95)
                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 5)
        )
        .padding()
    }

    private func weatherIcon(for weather: String) -> String {
        switch weather {
        case "Clear":
            return "sun.max.fill"
        case "Clouds":
            return "cloud.fill"
        case "Rain":
            return "cloud.rain.fill"
        default:
            return "cloud.fill"
        }
    }
}



    private func weatherIcon(for weather: String) -> String {
        switch weather {
        case "Clear":
            return "sun.max.fill"
        case "Clouds":
            return "cloud.fill"
        case "Rain":
            return "cloud.rain.fill"
        default:
            return "cloud.fill"
        }
    }

struct MapBackground: View {
    let latitude: Double
    let longitude: Double
    let apiKey = ""

    var body: some View {
        ZStack {
            // Background map image
            AsyncImage(url: URL(string: mapURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                case .failure:
                    Color.blue
                case .empty:
                    ProgressView()
                }
            }
            .overlay(
                Color.black.opacity(0.3)
            )
            .background(Color.blue)
        }
    }

    private var mapURL: String {
        return "https://maps.googleapis.com/maps/api/staticmap?center=\(latitude),\(longitude)&zoom=12&size=400x400&scale=2&maptype=satellite&markers=color:red%7C\(latitude),\(longitude)&key=\(apiKey)"
    }
}
