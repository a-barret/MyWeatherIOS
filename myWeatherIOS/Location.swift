//
//  Location.swift
//  myWeather
//
//  Created by Aiden Barrett on 4/30/25.
//

import Foundation

class Location {
    let name: String
    var currentWeather: WeatherData?
    
    init(name: String) {
        self.name = name
    }
}
