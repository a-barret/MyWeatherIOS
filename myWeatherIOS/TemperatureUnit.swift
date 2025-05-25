//
//  TemperatureUnit.swift
//  myWeatherIOS
//
//  Created by Aiden Barrett on 5/24/25.
//

import Foundation

enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius = "°C"
    case fahrenheit = "°F"
    
    var id: String { self.rawValue }
}
