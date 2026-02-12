//
//  WeatherUpdater.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 10/04/2023.
//

import Combine
import CoreLocation
import SwiftUI
import AppKit

class WeatherUpdater: ObservableObject {
    
    @Published var locationPlacemark: CLPlacemark?
    @Published var CustomWeather: CustomWeatherModel?
    @AppStorage("showIcon") var showIcon: Bool = true
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("showUnits") var showUnits: Bool = true
    @AppStorage("showFeelsLike") var showFeelsLike: Bool = false
    @AppStorage("monocromeIcon") var monocromeIcon: Bool = false
    
    @Published var errorCustomWeather: Bool = false
    
    @AppStorage("openWeatherAPIKey") var apiKey: String = ""
    @AppStorage("openWeather") var openWeather: Bool = false
    
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
        if let location = locationManager.currentLocation {
            fetchOpenWeather(for: location)
        }
    }
    
    func fetchOpenWeather(for location: CLLocation){
        guard let urlString =
                "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(location.coordinate.latitude),\(location.coordinate.longitude)&days=3&aqi=no&alerts=no".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error: Failed to encode URL")
            DispatchQueue.main.async {
                self.errorCustomWeather = true
            }
            return
        }
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            DispatchQueue.main.async {
                self.errorCustomWeather = true
            }
            return
        }
        URLSession.shared.dataTask(with: url){ data, response, error in
            if let error = error {
                print("Error fetching weather data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorCustomWeather = true
                }
                return
            }
            
            guard let data = data else {
                print("Error: No data received from API")
                DispatchQueue.main.async {
                    self.errorCustomWeather = true
                }
                return
            }
            
            // Log the response for debugging
            if let httpResponse = response as? HTTPURLResponse {
                print("API Response Status Code: \(httpResponse.statusCode)")
            }
            
            DispatchQueue.main.async{
                do {
                    let response = try JSONDecoder().decode(CustomWeatherModel.self, from: data)
                    self.CustomWeather = response
                    self.updateMenubarCustomWeather()
                    self.errorCustomWeather = false
                } catch {
                    print("Error decoding weather data: \(error)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response data: \(jsonString)")
                    }
                    self.errorCustomWeather = true
                }
            }
            self.locationManager.getPlace(for: location) { locationPlace in
                DispatchQueue.main.async {
                    self.locationPlacemark = locationPlace
                }
            }
        }.resume()
    }
    
    private func updateMenubarCustomWeather(){
        @AppStorage("menuBarInfo") var menuBarInfo: MenuBarInfo = .temperature
        let precipitationChance = CustomWeather?.current.chanceOfRain ?? 0
        let precipitationChanceString = "\(Int(precipitationChance * 100))%"
        
        DispatchQueue.main.async{
            guard let weather = self.CustomWeather else {return}
            guard let menubar = AppDelegate.shared.statusItem?.button else {return}
            menubar.image = nil
            if self.showIcon{
                if self.monocromeIcon{
                    menubar.image = NSImage(systemSymbolName: "cloudy", accessibilityDescription: nil)
                }else{
                    if (weather.current.isDay == 0){
                        if let image = NSImage(named: NSImage.Name(menubariconCustom(condition: weather.current.condition.text, isDay: false))) {
                            let resized = image.resizedMaintainingAspectRatio(width: 24, height: 24)
                            menubar.image = resized
                        } else {
                            let defaultImage = NSImage(named: "mostlyclear")?.resizedMaintainingAspectRatio(width: 24, height: 24)
                            menubar.image = defaultImage
                            print("Error: Failed to load image from assets folder.")
                        }
                    }else{
                        if let image = NSImage(named: NSImage.Name(menubariconCustom(condition: weather.current.condition.text, isDay: true))) {
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
                menubar.title = localisedTemp(tempInCelsius: weather.current.tempC, isCelsius: self.isCelsius, showUnits: self.showUnits)
                case .feelslike:
                menubar.title = localisedTemp(tempInCelsius: weather.current.feelslikeC, isCelsius: self.isCelsius, showUnits: self.showUnits)
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
