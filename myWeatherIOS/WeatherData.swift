//
//  WeatherData.swift
//  myWeather
//
//  Created by Aiden Barrett on 5/8/25.
//

import Foundation

struct WeatherData: Codable {
    let temperature: Double
    let humidity: Int
    let windSpeed: Double
    let condition: String
}
