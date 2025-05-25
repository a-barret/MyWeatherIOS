//
//  WeatherService.swift
//  myWeather
//
//  Created by Aiden Barrett on 5/8/25.
//

import Foundation

class WeatherService : ObservableObject{
    private let apiKey = "" // Replace with your valid API key
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private var unitPreference = "imperial"
    
    enum WeatherError: Error {
        case requestFailed(String)
    }
    
    func fetchWeather(for location: Location) async throws -> WeatherData {
        let query = "q=\(location.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&appid=\(apiKey)&units=\(unitPreference)"
        guard let url = URL(string: "\(baseURL)?\(query)") else {
            print("Invalid URL: \(baseURL)?\(query)")
            throw WeatherError.requestFailed("Invalid URL")
        }
        print("Fetching from URL: \(url)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("No HTTP response")
            throw WeatherError.requestFailed("Invalid response")
        }
        print("HTTP Status Code: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            print("Invalid response: Status code \(httpResponse.statusCode)")
            throw WeatherError.requestFailed("Invalid response or city not found (Status: \(httpResponse.statusCode))")
        }
        
        do {
            let responseData = try JSONDecoder().decode(WeatherResponse.self, from: data)
            print("Decoded response: \(responseData)")
            return WeatherData(
                temperature: responseData.main.temp,
                humidity: responseData.main.humidity,
                windSpeed: responseData.wind.speed,
                condition: responseData.weather.first?.description ?? "Unknown"
            )
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            throw WeatherError.requestFailed("Failed to decode response: \(error.localizedDescription)")
        }
    }
    
    func setUnitPreference(unitType: TemperatureUnit) {
        switch unitType {
        case .celsius:
            unitPreference = "metric"
        case .fahrenheit:
            unitPreference = "imperial"
        }
    }
}
