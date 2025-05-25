//
//  ContentView.swift
//  myWeatherIOS
//
//  Created by Aiden Barrett on 5/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var weatherService = WeatherService()
    @State private var city: String = ""
    @State private var selectedUnit: TemperatureUnit = .fahrenheit // Default to Fahrenheit
    @State private var weather: WeatherData?
    @State private var errorMessage: String?
    
    private func fetchWeather() {
        guard !city.isEmpty else {
            errorMessage = "Please enter a city name"
            return
        }
        
        Task {
            do {
                let location = Location(name: city)
                let data = try await weatherService.fetchWeather(for: location)
                weather = data
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
                weather = nil
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Unit picker
                        HStack {
                            Spacer()
                            Picker("Select Unit", selection: $selectedUnit) {
                                ForEach(TemperatureUnit.allCases) { unit in
                                    Text(unit.rawValue)
                                        .tag(unit)
                                        .font(.system(size: 30))
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 100, alignment: .leading)
                            .onChange(of: selectedUnit) {
                                weatherService.setUnitPreference(unitType: selectedUnit)
                                if !city.isEmpty {
                                    fetchWeather()
                                }
                            }
                            .shadow(radius: 8)
                        }
                        .frame(alignment: .leading)
                        .padding()
                        
                        HStack {
                            Spacer()
                            TextField("Enter city name", text: $city)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 340)
                            Spacer()
                        }
                        
                        // Weather display
                        HStack {
                            Spacer()
                                .frame(width: 75)
                            VStack {
                                if let weather = weather {
                                    Text("Weather in \(city.capitalized):")
                                        .font(.title)
                                    Spacer()
                                    Text("Temperature: \(weather.temperature, specifier: "%.1f") \(selectedUnit.rawValue)")
                                    Text("Condition: \(weather.condition.capitalized)")
                                    Text("Humidity: \(weather.humidity)%")
                                    Text("Wind Speed: \(weather.windSpeed, specifier: "%.1f") \(selectedUnit == .celsius ? "km/h" : "mph")")
                                }
                            }
                        }
                        // Error display
                        if let errorMessage = errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            fetchWeather()
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .frame(width: 50, height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .shadow(radius: 8)
                        .padding()
                    }
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
