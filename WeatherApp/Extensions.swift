//
//  Extensions.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 01/01/2023.
//

import Foundation
import SwiftUI


extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}

extension String{
    func roundedTemp() -> String{
        return String(Int(round(Double(self) ?? 0.0 )))
        
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

let conditionToReadable: [String: String] = [
    "Sunny": "Sunny",
    "Clear": "Clear",
    "Partly cloudy": "Partly Cloudy",
    "Cloudy": "Cloudy",
    "Overcast": "Overcast",
    "Mist": "Mist",
    "Patchy rain possible": "Partial Rain",
    "Patchy snow possible": "Partial Snow",
    "Patchy sleet possible": "Partial Sleet",
    "Patchy freezing drizzle possible": "Drizzle",
    "Thundery outbreaks possible": "Thunderstorms",
    "Blowing snow": "Blowing Snow",
    "Blizzard": "Blizzard",
    "Fog": "Fog",
    "Freezing fog": "Freezing Fog",
    "Patchy light drizzle": "Light Drizzle",
    "Light drizzle": "Light Drizzle",
    "Freezing drizzle": "Freezing Drizzle",
    "Heavy freezing drizzle": "Heavy Drizzle",
    "Patchy light rain": "Light Rain",
    "Light rain": "Light Rain",
    "Moderate rain at times": "Moderate Rain",
    "Moderate rain": "Moderate Rain",
    "Heavy rain at times": "Heavy Rain",
    "Heavy rain": "Heavy Rain",
    "Light freezing rain": "Freezing Rain",
    "Moderate or heavy freezing rain": "Heavy Freezing Rain",
    "Light sleet": "Light Sleet",
    "Moderate or heavy sleet": "Heavy Sleet",
    "Patchy light snow": "Light Snow",
    "Light snow": "Light Snow",
    "Patchy moderate snow": "Moderate Snow",
    "Moderate snow": "Moderate Snow",
    "Patchy heavy snow": "Heavy Snow",
    "Heavy snow": "Heavy Snow",
    "Ice pellets": "Ice Pellets",
    "Light rain shower": "Rain Shower",
    "Moderate or heavy rain shower": "Heavy Rain Shower",
    "Torrential rain shower": "Heavy Rain",
    "Light sleet showers": "Sleet Showers",
    "Moderate or heavy sleet showers": "Heavy Sleet Showers",
    "Light snow showers": "Snow Showers",
    "Moderate or heavy snow showers": "Heavy Snow Showers",
    "Light showers of ice pellets": "Ice Pellet Showers",
    "Moderate or heavy showers of ice pellets": "Heavy Ice Pellet Showers",
    "Patchy light rain with thunder": "Light Rain with Thunder",
    "Moderate or heavy rain with thunder": "Rain with Thunder",
    "Patchy light snow with thunder": "Snow with Thunder",
    "Moderate or heavy snow with thunder": "Heavy Snow with Thunder"
]

func customWeatherToReadableCondition(condition: String) -> String {
    return conditionToReadable[condition] ?? condition
}


func menubariconCustom(condition: String, isDay: Bool) -> String {
    let conditionToIcon: [String: String] = [
        "Sunny": "clear-day",
        "Clear": "clear-night",
        "Partly cloudy": "partly-cloudy-day",
        "Cloudy": "cloudy",
        "Overcast": "cloudy",
        "Mist": "fog",
        "Patchy rain possible": "drizzle",
        "Patchy snow possible": "snow",
        "Patchy sleet possible": "snow",
        "Patchy freezing drizzle possible": "drizzle",
        "Thundery outbreaks possible": "strongstorms",
        "Blowing snow": "heavysnow",
        "Blizzard": "heavysnow",
        "Fog": "fog",
        "Freezing fog": "fog",
        "Patchy light drizzle": "drizzle",
        "Light drizzle": "drizzle",
        "Freezing drizzle": "drizzle",
        "Heavy freezing drizzle": "drizzle",
        "Patchy light rain": "rain",
        "Light rain": "rain",
        "Moderate rain at times": "heavyrain",
        "Moderate rain": "heavyrain",
        "Heavy rain at times": "heavyrain",
        "Heavy rain": "heavyrain",
        "Light freezing rain": "rain",
        "Moderate or heavy freezing rain": "heavyrain",
        "Light sleet": "snow",
        "Moderate or heavy sleet": "snow",
        "Patchy light snow": "snow",
        "Light snow": "snow",
        "Patchy moderate snow": "snow",
        "Moderate snow": "snow",
        "Patchy heavy snow": "heavysnow",
        "Heavy snow": "heavysnow",
        "Ice pellets": "snow",
        "Light rain shower": "sunshowers",
        "Moderate or heavy rain shower": "heavyrain",
        "Torrential rain shower": "heavyrain",
        "Light sleet showers": "snow",
        "Moderate or heavy sleet showers": "snow",
        "Light snow showers": "snow",
        "Moderate or heavy snow showers": "heavysnow",
        "Light showers of ice pellets": "snow",
        "Moderate or heavy showers of ice pellets": "heavysnow",
        "Patchy light rain with thunder": "strongstorms",
        "Moderate or heavy rain with thunder": "strongstorms",
        "Patchy light snow with thunder": "strongstorms",
        "Moderate or heavy snow with thunder": "strongstorms",
        "Unknown": "Unknown"
    ]
    
    var iconName = conditionToIcon[condition] ?? "cloud"
    
    if !isDay {
        switch iconName {
        case "clear-day":
            iconName = "clear-night"
        case "partly-cloudy-day":
            iconName = "partly-cloudy-night"
        default:
            iconName = "night-\(iconName)"
        }
    }
    
    return iconName
}

func localisedTemp(tempInCelsius: Double, isCelsius: Bool, showUnits: Bool) -> String{
    if isCelsius {
        return String(tempInCelsius).roundedTemp() + (showUnits ? "℃" : "°")
    }
    let fahrenheitTemp = (tempInCelsius * 1.8) + 32
    return String(fahrenheitTemp).roundedTemp() + (showUnits ? "℉" : "°")
}

