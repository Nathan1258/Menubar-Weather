//
//  BackgroundManager.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 02/01/2023.
//

import Foundation

import Foundation
import WeatherKit
import SwiftUI

func GetBackgroundCustomWeather(condition: String, isDaylight: Bool) -> LinearGradient{
    if !isDaylight{
        return LinearGradient(colors: [Color(hex: "FFFBAB"), Color(hex: "5838B7"), Color(hex: "5422B5"), Color(hex: "5022AE")], startPoint: .topTrailing, endPoint: .bottom)
    }
    switch condition{
    case "Clear":
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom)
    case "Cloudy":
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom)
    case "Mostly clear":
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topLeading, endPoint: .bottom)
    case "Mostly cloudy":
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom)
    case "Partly cloudy":
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom)
    case "Mist", "Fog", "Freezing fog":
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom)
    case "Light rain shower":
        return LinearGradient(colors: [Color(hex: "A0B1BA"), Color(hex: "98A8B0"), Color(hex: "72C9D9"), Color(hex: "70ACB7")], startPoint: .topTrailing, endPoint: .bottom)
    case "Heavy rain at times", "Heavy rain":
        return LinearGradient(colors: [Color(hex: "A0B1BA"), Color(hex: "98A8B0"), Color(hex: "72C9D9"), Color(hex: "70ACB7")], startPoint: .topTrailing, endPoint: .bottom)
    case "Patchy rain possible", "Overcast":
        return LinearGradient(colors: [Color(hex: "94E1EF"), Color(hex: "83D8E7"), Color(hex: "72C9D9"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom)
    case "Thundery outbreaks possible", "Patchy light rain with thunder", "Moderate or heavy rain with thunder":
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom)
    case "Sunny":
        return LinearGradient(colors: [Color(hex: "FBE35C"), Color(hex: "6EBEB2"), Color(hex: "68ADC7"), Color(hex: "5A8FD1"), Color(hex: "547EDF")], startPoint: .topTrailing, endPoint: .bottom)
    case "Light snow showers", "Patchy snow possible", "Patchy light snow", "Light snow", "Patchy moderate snow", "Moderate snow":
        return LinearGradient(colors: [Color(hex: "ECECFA"), Color(hex: "D1D5F5"), Color(hex: "DFE1F7"), Color(hex: "BABFF6"), Color(hex: "A2A7EE")], startPoint: .topTrailing, endPoint: .bottom)
    case "Moderate or heavy snow showers":
        return LinearGradient(colors: [Color(hex: "ECECFA"), Color(hex: "D1D5F5"), Color(hex: "DFE1F7"), Color(hex: "BABFF6"), Color(hex: "A2A7EE")], startPoint: .topTrailing, endPoint: .bottom)
    default:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom)
    }
}
