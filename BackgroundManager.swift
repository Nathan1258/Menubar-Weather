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


func GetBackground(condition: WeatherCondition, isDaylight: Bool) -> LinearGradient{
    if !isDaylight{
        return LinearGradient(colors: [Color(hex: "FFFBAB"), Color(hex: "5838B7"), Color(hex: "5422B5"), Color(hex: "5022AE")], startPoint: .topTrailing, endPoint: .bottom) // done
    }
    switch condition{
    case .clear:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom) // done
    case .cloudy:
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) // done
    case .mostlyClear:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topLeading, endPoint: .bottom) // done
    case .mostlyCloudy:
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) // done
    case .partlyCloudy:
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) // done
    case .breezy:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom) // temp
    case .windy:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom) // temp
    case .drizzle:
        return LinearGradient(colors: [Color(hex: "A0B1BA"), Color(hex: "98A8B0"), Color(hex: "72C9D9"), Color(hex: "70ACB7")], startPoint: .topTrailing, endPoint: .bottom) // done
    case .rain:
        return LinearGradient(colors: [Color(hex: "A0B1BA"), Color(hex: "98A8B0"), Color(hex: "72C9D9"), Color(hex: "70ACB7")], startPoint: .topTrailing, endPoint: .bottom) // done
    case .heavyRain:
        return LinearGradient(colors: [Color(hex: "A0B1BA"), Color(hex: "98A8B0"), Color(hex: "72C9D9"), Color(hex: "70ACB7")], startPoint: .topTrailing, endPoint: .bottom) // done
    case .sunShowers:
        return LinearGradient(colors: [Color(hex: "94E1EF"), Color(hex: "83D8E7"), Color(hex: "72C9D9"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) //
    case .strongStorms:
        return LinearGradient(colors: [Color(hex: "94E1EF"), Color(hex: "83D8E7"), Color(hex: "72C9D9"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) //
    case .thunderstorms:
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) // done
    case .hot:
        return LinearGradient(colors: [Color(hex: "FBE35C"), Color(hex: "6EBEB2"), Color(hex: "68ADC7"), Color(hex: "5A8FD1"), Color(hex: "547EDF")], startPoint: .topTrailing, endPoint: .bottom) //
    case .snow:
        return LinearGradient(colors: [Color(hex: "ECECFA"), Color(hex: "D1D5F5"), Color(hex: "DFE1F7"), Color(hex: "BABFF6"), Color(hex: "A2A7EE")], startPoint: .topTrailing, endPoint: .bottom)
    case .heavySnow:
        return LinearGradient(colors: [Color(hex: "ECECFA"), Color(hex: "D1D5F5"), Color(hex: "DFE1F7"), Color(hex: "BABFF6"), Color(hex: "A2A7EE")], startPoint: .topTrailing, endPoint: .bottom)
    default:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom) // done
    }
}


func GetBackgroundPreview(num: Int) -> LinearGradient{
    switch num{
    case 1:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom) // done
    case 2:
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) // done
    case 3:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topLeading, endPoint: .bottom) // done
    case 4:
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) // done
    case 5:
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) // done
    case 6:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom) // temp
    case 7:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom) // temp
    case 8:
        return LinearGradient(colors: [Color(hex: "A0B1BA"), Color(hex: "98A8B0"), Color(hex: "72C9D9"), Color(hex: "70ACB7")], startPoint: .topTrailing, endPoint: .bottom) // done
    case 9:
        return LinearGradient(colors: [Color(hex: "A0B1BA"), Color(hex: "98A8B0"), Color(hex: "72C9D9"), Color(hex: "70ACB7")], startPoint: .topTrailing, endPoint: .bottom) // done
    case 10:
        return LinearGradient(colors: [Color(hex: "A0B1BA"), Color(hex: "98A8B0"), Color(hex: "72C9D9"), Color(hex: "70ACB7")], startPoint: .topTrailing, endPoint: .bottom) // done
    case 11:
        return LinearGradient(colors: [Color(hex: "94E1EF"), Color(hex: "83D8E7"), Color(hex: "72C9D9"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) //
    case 12:
        return LinearGradient(colors: [Color(hex: "94E1EF"), Color(hex: "83D8E7"), Color(hex: "72C9D9"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) //
    case 13:
        return LinearGradient(colors: [Color(hex: "A0B1BA"),Color(hex: "8FA0A8"), Color(hex: "70808B"), Color(hex: "5A6D79")], startPoint: .topTrailing, endPoint: .bottom) // done
    case 14:
        return LinearGradient(colors: [Color(hex: "FBE35C"), Color(hex: "6EBEB2"), Color(hex: "68ADC7"), Color(hex: "5A8FD1"), Color(hex: "547EDF")], startPoint: .topTrailing, endPoint: .bottom) //
    case 15:
        return LinearGradient(colors: [Color(hex: "ECECFA"), Color(hex: "D1D5F5"), Color(hex: "DFE1F7"), Color(hex: "BABFF6"), Color(hex: "A2A7EE")], startPoint: .topTrailing, endPoint: .bottom)
    case 16:
        return LinearGradient(colors: [Color(hex: "ECECFA"), Color(hex: "D1D5F5"), Color(hex: "DFE1F7"), Color(hex: "BABFF6"), Color(hex: "A2A7EE")], startPoint: .topTrailing, endPoint: .bottom)
    default:
        return LinearGradient(colors: [Color(hex: "6FC1B1"), Color(hex: "639ED7"), Color(hex: "547EDC")], startPoint: .topTrailing, endPoint: .bottom) // done
    }
}
