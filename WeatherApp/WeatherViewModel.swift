//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 김형준 on 6/25/24.
//

import Foundation
import WeatherKit
import CoreLocation

let weatherService = WeatherService.shared

extension WeatherService {
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        let Weather = try await weatherService.weather(for: location)
        return WeatherData(from: Weather.currentWeather)
    }
}

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var isLoading: Bool = true
    @Published var error: Error?
    @Published var location: CLLocation = CLLocation(latitude: 37.5665, longitude: 126.9780)
    private var weatherService = WeatherService()
    
  
    
    @MainActor
    func updateUI(_ error: Error?, _ isLoading: Bool, _ weather: WeatherData?) async {
        self.error = error
        self.weather = weather
        self.isLoading = isLoading
    }
    
    func fetchWeather() async {
        Task {
            do {
                let fetchWeather = try await weatherService.fetchWeather(for: location)
                await updateUI(nil, false, fetchWeather)
            }
            catch {
               await updateUI(error, false, nil)
            }
        }
    }
  
}


