//
//  ContentView.swift
//  WeatherApp
//
//  Created by 김형준 on 6/25/24.
//

import SwiftUI
import CoreLocation
import WeatherKit
import MapKit




struct ContentView: View {
    
    
    @State var IsSheetShowing = false
    @StateObject var viewModel = WeatherViewModel()
    @StateObject var locationManager = LocationManager()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Spacer()
                VStack {
                    Spacer()
                    Image(systemName: viewModel.weather?.symbolName ?? "questionmark.circle")
                        .font(.system(size: 80))
                    Text("\(String(format: "%.1f", viewModel.weather?.temperature ?? 0))°")
                        .bold()
                        .font(.system(size: 100))
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Spacer()
                        Text("\(String(format: "%.1f", viewModel.weather!.humidity * 100 ?? 0))%")
                        
                        Spacer()
                        Text("\(String(format: "%.1f", viewModel.weather!.windSpeed)) m/s")
                        Spacer()
                    }
                    Spacer()
                    Text("\(viewModel.weather!.description)")
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
                                ZStack{
                                    MapView(selectedCoordinate: $selectedCoordinate)
                                        .edgesIgnoringSafeArea(.all)
                                        .onDisappear {
                                            if let coordinate = selectedCoordinate {
                                                viewModel.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                                Task {
                                                    await viewModel.fetchWeather()
                                                }
                                            }
                                        }
                                    VStack{
                                        Spacer()
                                        Button(action: {
                                            IsSheetShowing = false
                                        }) { Text("현재 위치 선택하기")}
                                            .padding()
                                            .background(Color.white)
                                        .cornerRadius(10)                                    }
                                }
                            
                                
                            }
                            .padding(.vertical)
                            Button(action: {
                                if let location = locationManager.location {
                                    viewModel.location = location
                                    Task {
                                        await viewModel.fetchWeather()
                                    }
                                }
                            }) {
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
        .onChange(of: locationManager.location) { nowlocation in
            if let location = nowlocation {
                viewModel.location = location
                Task {
                    await viewModel.fetchWeather()
                }
            }
            
        }
    }
    
}

#Preview {
    ContentView()
}
