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
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var location: CLLocation

    private var weatherService: WeatherService
    
    init(location: CLLocation, weatherService: WeatherService) {
        self.location = location
        self.weatherService = weatherService
        }
    
    @MainActor
    func updateUI(_ error: Error?, _ isLoading: Bool, _ weather: WeatherData?) async {
        self.error = error
        self.weather = weather
        self.isLoading = isLoading
    }
    
    func fetchWeather() {
        isLoading = true
        error  = nil
        Task {
            do {
                let fetchWeather = try await weatherService.fetchWeather(for: location)
                await updateUI(nil, false, fetchWeather)
            }
            catch {
               await updateUI(error, true, nil)
            }
        }
    }
  
}
