//
//  ContentView.swift
//  WeatherApp
//
//  Created by 김형준 on 6/25/24.
//

import SwiftUI
import CoreLocation
import WeatherKit

let weatherService = WeatherService.shared

extension WeatherService {
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        let Weather = try await weatherService.weather(for: location)
        return WeatherData(from: Weather.currentWeather)
    }
}




struct ContentView: View {
    
    @State var IsSheetShowing = false
    @StateObject var viewModel: WeatherViewModel
    
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            Spacer()
            VStack {
                Spacer()
                Text("온도")
                    .bold()
                    .font(.system(size: 120))
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    Spacer()
                    Text("습도")
                    
                    Spacer()
                    Text("풍속")
                    Spacer()
                }
                Spacer()
                Text("설명란")
                Spacer()
                HStack{
                    Spacer()
                    VStack{
                        Button(action: {
                            IsSheetShowing = true
                        }) {
                            Image(systemName: "location.fill")
                                .foregroundStyle(.black)
                                .font(.title)
                            
                        }
                        .sheet(isPresented: $IsSheetShowing) {
                            Text("위치입력창")
                        }
                        .padding(.vertical)
                        Button(action: {}) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundStyle(.black)
                                .font(.title)
                            
                        }
                        
                    }
                    .padding(.horizontal)
                }
                
            }
            
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
