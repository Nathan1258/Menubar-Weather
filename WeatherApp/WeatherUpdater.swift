//
//  WeatherUpdater.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 10/04/2023.
//

import Combine
import CoreLocation
import SwiftUI
import WeatherKit
import AppKit

class WeatherUpdater: ObservableObject {
    @Published var weather: Weather?
    @Published var hourlyWeather: Forecast<HourWeather>?
    @Published var locationPlacemark: CLPlacemark?
    @AppStorage("showIcon") var showIcon: Bool = true
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("showFeelsLike") var showFeelsLike: Bool = false
    
    private let weatherService = WeatherService.shared
    
    private var timer: Timer?
    
    private let locationManager: LocationManager
    
    private var backgroundScheduler: NSBackgroundActivityScheduler
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.backgroundScheduler = NSBackgroundActivityScheduler(identifier: "com.ellisn.WeatherApp")
        self.backgroundScheduler.repeats = true
        self.backgroundScheduler.qualityOfService = .userInteractive
        setupBackgroundScheduler()
    }
    
    private func setupBackgroundScheduler() {
            let nextHourInterval = intervalToNextHour()
            print(nextHourInterval)
            backgroundScheduler.interval = nextHourInterval
            scheduleBackgroundWeatherUpdate()
        }

    private func intervalToNextHour() -> TimeInterval {
        let calendar = Calendar.current
        let nextHour = calendar.nextDate(after: Date(), matching: DateComponents(minute: 0), matchingPolicy: .nextTime)!
        return nextHour.timeIntervalSinceNow + 180
    }

    private func scheduleBackgroundWeatherUpdate() {
        backgroundScheduler.schedule { completion in
            self.fetchData()
            print("Updating weather...")
            self.backgroundScheduler.interval = 3600

            completion(.finished)
        }
    }
    
    func fetchData() {
        Task {
            var dayComponent = DateComponents()
            dayComponent.day = 7
            let dateSevenDaysTime = Calendar.current.date(byAdding: dayComponent, to: Date())
            do {
                if let location = locationManager.currentLocation {
                    let fetchedWeather = try await weatherService.weather(for: location)
                    let fetchedHourlyWeather = try await weatherService.weather(for: location, including: .hourly(startDate: Date(), endDate: dateSevenDaysTime!))
                    DispatchQueue.main.async {
                        self.weather = fetchedWeather
                        self.hourlyWeather = fetchedHourlyWeather
                    }
                    locationManager.getPlace(for: location) { locationPlace in
                        DispatchQueue.main.async {
                            self.locationPlacemark = locationPlace
                        }
                    }
                    updateMenubar()
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func updateMenubar() {
        DispatchQueue.main.async {
            guard let weather = self.weather else {return}
            guard let menubar = AppDelegate.shared.statusItem?.button else {return}
            menubar.image = nil
            if self.showIcon{
                menubar.image = NSImage(systemSymbolName: weather.currentWeather.symbolName, accessibilityDescription: nil)
            }
            if self.showFeelsLike{
                menubar.title = localisedTemp(tempInCelsius: weather.currentWeather.apparentTemperature.value, isCelsius: self.isCelsius)
            }else{
                menubar.title = localisedTemp(tempInCelsius: weather.currentWeather.temperature.value, isCelsius: self.isCelsius)
            }
        }
    }
}
