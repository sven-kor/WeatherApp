//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 김형준 on 6/25/24.
//

import Foundation
import WeatherKit

struct WeatherData: Codable {
    var temperature: Double
    var description: String
    var humidity: Double
    var windSpeed: Double
    
    init(from currentWeather: CurrentWeather) {
        self.temperature = currentWeather.temperature.value
        self.description = currentWeather.date.description
        self.humidity = currentWeather.humidity
        self.windSpeed = currentWeather.wind.speed.value
    }
}
