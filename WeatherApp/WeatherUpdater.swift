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
    @AppStorage("monocromeIcon") var monocromeIcon: Bool = false
    
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
        @AppStorage("menuBarInfo") var menuBarInfo: MenuBarInfo = .temperature
        let precipitationChance = hourlyWeather?.forecast.first?.precipitationChance ?? 0.0
        let precipitationChanceString = "\(Int(precipitationChance * 100))%"
        
        DispatchQueue.main.async {
            guard let weather = self.weather else {return}
            guard let menubar = AppDelegate.shared.statusItem?.button else {return}
            menubar.image = nil
            if self.showIcon{
                if self.monocromeIcon{
                    menubar.image = NSImage(systemSymbolName: weather.currentWeather.symbolName, accessibilityDescription: nil)
                }else{
                    if !weather.currentWeather.isDaylight{
                        if let image = NSImage(named: NSImage.Name("night-"+weather.currentWeather.symbolName)) {
                            let resized = image.resizedMaintainingAspectRatio(width: 24, height: 24)
                            menubar.image = resized
                        } else {
                            let defaultImage = NSImage(named: "mostlyclear")?.resizedMaintainingAspectRatio(width: 24, height: 24)
                            menubar.image = defaultImage
                            print("Error: Failed to load image from assets folder.")
                        }
                    }else{
                        if let image = NSImage(named: NSImage.Name(weather.currentWeather.symbolName)) {
                            let resized = image.resizedMaintainingAspectRatio(width: 24, height: 24)
                            menubar.image = resized
                        } else {
                            let defaultImage = NSImage(named: "mostlyclear")?.resizedMaintainingAspectRatio(width: 24, height: 24)
                            menubar.image = defaultImage
                            print("Error: Failed to load image from assets folder.")
                        }
                    }
                }
            }
            switch menuBarInfo{
            case .temperature:
                menubar.title = localisedTemp(tempInCelsius: weather.currentWeather.temperature.value, isCelsius: self.isCelsius)
            case .feelslike:
                menubar.title = localisedTemp(tempInCelsius: weather.currentWeather.apparentTemperature.value, isCelsius: self.isCelsius)
            case .chanceOfPerception:
                menubar.title = precipitationChanceString
            }
        }
    }
}

extension NSImage {
    func resizedMaintainingAspectRatio(width: CGFloat, height: CGFloat) -> NSImage {
        let ratioX = width / size.width
        let ratioY = height / size.height
        let ratio = ratioX < ratioY ? ratioX : ratioY
        let newHeight = size.height * ratio
        let newWidth = size.width * ratio
        let newSize = NSSize(width: newWidth, height: newHeight)
        let image = NSImage(size: newSize, flipped: false) { destRect in
            NSGraphicsContext.current!.imageInterpolation = .high
            self.draw(in: destRect, from: NSZeroRect, operation: .copy, fraction: 1)
            return true
        }
        return image
    }
}
