import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var weatherService = WeatherService()
    @State private var searchText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                if let weatherData = weatherService.weatherData {
                    BackgroundView(weather: weatherData.weather.first?.description ?? "Clear")
                } else {
                    Color.blue.edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    HStack {
                        TextField("Enter city name", text: $searchText, onCommit: {
                            weatherService.fetchWeather(for: searchText)
                            hideKeyboard()
                        })
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
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
                    .padding(.top)
                    
                    if let weatherData = weatherService.weatherData {
                        WeatherView(weatherData: weatherData)
                            .transition(.slide)
                    } else {
                        ProgressView("Fetching Weather...")
                            .padding()
                    }
                    
                    Spacer()
                }
                .navigationBarTitle("Weather", displayMode: .inline)
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
                Image(systemName: "humidity")
                    .foregroundColor(.blue)
                Text("Humidity: \(weatherData.main.humidity, specifier: "%.0f")%") // Format humidity to one decimal place
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
            .padding(.top)
            
            Spacer()
        }
        .padding(20)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
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

struct BackgroundView: View {
    let weather: String
    
    var body: some View {
        ZStack {
            switch weather {
            case "Clear":
                SunnyView()
            case "Clouds":
                CloudyView()
            case "Rain":
                RainyView()
            default:
                Color.blue.edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SunnyView: View {
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let sunPath = Path { path in
                        path.addArc(center: CGPoint(x: size.width / 2, y: size.height / 4),
                                    radius: 60,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360),
                                    clockwise: false)
                    }
                    context.fill(sunPath, with: .color(.yellow))
                }
            }
        }
    }
}

struct CloudyView: View {
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let cloudPath = Path { path in
                        path.addRoundedRect(in: CGRect(x: size.width / 4, y: size.height / 4, width: size.width / 2, height: size.height / 4),
                                            cornerSize: CGSize(width: 40, height: 40))
                    }
                    context.fill(cloudPath, with: .color(.white))
                }
            }
        }
    }
}

struct RainyView: View {
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let raindropPath = Path { path in
                        for _ in 0..<10 {
                            let x = CGFloat.random(in: 0..<size.width)
                            let y = CGFloat.random(in: 0..<size.height)
                            path.addEllipse(in: CGRect(x: x, y: y, width: 5, height: 10))
                        }
                    }
                    context.fill(raindropPath, with: .color(.white))
                }
            }
        }
    }
}
