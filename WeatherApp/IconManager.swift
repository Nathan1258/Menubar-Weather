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
        if !isDaylight {return Image("night-strongstorms")}
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

func GetCustomWeatherIcon(condition: String, isDaylight: Bool) -> Image {
    switch condition {
    case "Sunny", "Clear":
        if !isDaylight { return Image("night-clear") }
        return Image("clear")
    case "Partly cloudy", "Mostly clear", "Mostly cloudy":
        if !isDaylight { return Image("night-cloudy") }
        return Image("cloudy")
    case "Cloudy", "Overcast":
        if !isDaylight { return Image("night-cloudy") }
        return Image("cloudy")
    case "Mist", "Fog", "Freezing fog":
        if !isDaylight { return Image("night-fog") }
        return Image("fog")
    case "Patchy rain possible", "Patchy light drizzle", "Light drizzle", "Patchy light rain", "Light rain", "Moderate rain at times", "Moderate rain":
        if !isDaylight { return Image("night-rain") }
        return Image("rain")
    case "Heavy rain at times", "Heavy rain":
        if !isDaylight { return Image("night-heavyrain") }
        return Image("heavyrain")
    case "Light freezing rain", "Moderate or heavy freezing rain":
        if !isDaylight { return Image("night-freezingrain") }
        return Image("freezingrain")
    case "Patchy snow possible", "Patchy light snow", "Light snow", "Patchy moderate snow", "Moderate snow":
        if !isDaylight { return Image("night-snow") }
        return Image("snow")
    case "Patchy heavy snow", "Heavy snow":
        if !isDaylight { return Image("night-heavysnow") }
        return Image("heavysnow")
    case "Patchy sleet possible", "Light sleet", "Moderate or heavy sleet":
        if !isDaylight { return Image("night-sleet") }
        return Image("sleet")
    case "Patchy freezing drizzle possible", "Freezing drizzle":
        if !isDaylight { return Image("night-freezingdrizzle") }
        return Image("freezingdrizzle")
    case "Thundery outbreaks possible", "Patchy light rain with thunder", "Moderate or heavy rain with thunder":
        if !isDaylight { return Image("night-strongstorms") }
        return Image("strongstorms")
    case "Blowing snow":
        if !isDaylight { return Image("night-snow") }
        return Image("snow")
    case "Blizzard":
        if !isDaylight { return Image("night-snow") }
        return Image("snow")
    case "Light rain shower":
        if !isDaylight { return Image("night-rain") }
        return Image("rain")
    case "Moderate or heavy rain shower":
        if !isDaylight { return Image("night-heavyrain") }
        return Image("heavyrain")
    case "Light sleet showers":
        if !isDaylight { return Image("night-sleet") }
        return Image("sleet")
    case "Moderate or heavy sleet showers":
        if !isDaylight { return Image("night-sleet") }
        return Image("sleet")
    case "Light snow showers":
        if !isDaylight { return Image("night-snow") }
        return Image("snow")
    case "Moderate or heavy snow showers":
        if !isDaylight { return Image("night-heavysnow") }
        return Image("heavysnow") 
    case "Hot":
        return Image("hot")
    default:
        return Image("cloudy")
    }
}

