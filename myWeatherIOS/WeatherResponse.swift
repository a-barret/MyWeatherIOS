//
//  WeatherResponse.swift
//  myWeather
//
//  Created by Aiden Barrett on 5/9/25.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    
    struct Main: Codable {
        let temp: Double
        let humidity: Int
    }
    
    struct Weather: Codable {
        let description: String
    }
    
    struct Wind: Codable {
        let speed: Double
    }
}
