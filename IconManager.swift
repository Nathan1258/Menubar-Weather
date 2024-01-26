//
//  IconManager.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 01/01/2023.
//

import Foundation
import WeatherKit
import SwiftUI


func GetIcon(condition: WeatherCondition, isDaylight: Bool) -> Image{
    switch condition{
    case .clear:
        if !isDaylight {return Image("night-clear")}
        return Image("clear")
    case .cloudy:
        if !isDaylight {return Image("night-cloudy")}
        return Image("cloudy")
    case .mostlyClear:
        if !isDaylight {return Image("night-cloudy")}
        return Image("mostlyclear")
    case .mostlyCloudy:
        if !isDaylight {return Image("night-cloudy")}
        return Image("cloudy")
    case .partlyCloudy:
        if !isDaylight {return Image("night-cloudy")}
        return Image("cloudy")
    case .breezy:
        if !isDaylight {return Image("night-windy")}
        return Image("breezy")
    case .windy:
        if !isDaylight {return Image("night-windy")}
        return Image("windy")
    case .drizzle:
        if !isDaylight {return Image("night-rain")}
        return Image("rain")
    case .rain:
        if !isDaylight {return Image("night-rain")}
        return Image("rain")
    case .heavyRain:
        if !isDaylight {return Image("night-heavyrain")}
        return Image("heavyrain")
    case .sunShowers:
        return Image("sunshowers")
    case .strongStorms:
        return Image("strongstorms")
    case .thunderstorms:
        if !isDaylight {return Image("night-stromstorms")}
        return Image("strongstorms")
    case .hot:
        return Image("hot")
    case .snow:
        if !isDaylight {return Image("night-snow")}
        return Image("snow")
    case .heavySnow:
        if !isDaylight {return Image("night-heavysnow")}
        return Image("heavysnow")
    default:
        return Image("cloudy")
    }
}
