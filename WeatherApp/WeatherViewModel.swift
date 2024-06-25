//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 김형준 on 6/25/24.
//

import Foundation
import WeatherKit
import CoreLocation
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var isLoaing: Bool = false
    @Published var error: Error?
    @Published var location: CLLocation

    private var weatherService: WeatherService
    
    init(location: CLLocation, weatherService: WeatherService) {
        self.location = location
        self.weatherService = weatherService
    }
    func fetchWeather() {
        isLoaing = true
        error  = nil
        Task {
            do {
                let fetchWeather = try await weatherService.fetchWeather(for: location)
                DispatchQueue.main.async {
                    self.weather = fetchWeather
                    self.isLoaing = false
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoaing = false
                }
            }
        }
    }
  
}
