//
//  MainView.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 01/01/2023.
//

import SwiftUI
import WeatherKit
import CoreLocation

func localisedTemp(tempInCelsius: Double, isCelsius: Bool) -> String{
    if isCelsius {
        return String(tempInCelsius).roundedTemp() + "℃"
    }
    let fahrenheitTemp = (tempInCelsius * 1.8) + 32
    return String(fahrenheitTemp).roundedTemp() + "℉"
}

struct MainView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    @StateObject private var weatherUpdater: WeatherUpdater
    
    init() {
        let locationManager = LocationManager()
        _locationManager = StateObject(wrappedValue: locationManager)
        _weatherUpdater = StateObject(wrappedValue: WeatherUpdater(locationManager: locationManager))
    }
    
    @State var showSettings: Bool = false
    @AppStorage("showBackground") var showBackground: Bool = true
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("showIcon") var showIcon: Bool = true
    @State var error: String = ""
    
    @State var previewNum: Int = 1
    
    var body: some View {
        if showSettings{
            SettingsView(showSettings: $showSettings)
        }else{
            VStack{
                if error.isEmpty{
                    if let weather = weatherUpdater.weather, let _ = weatherUpdater.hourlyWeather, let _ = weatherUpdater.locationPlacemark{
                        ZStack{
                            if showBackground{
                                GetBackground(condition: weather.currentWeather.condition, isDaylight: weather.currentWeather.isDaylight).ignoresSafeArea()
                            }
                            VStack{
                                Top(weather: $weatherUpdater.weather, hourlyWeather: $weatherUpdater.hourlyWeather ,locationPlacemark: $weatherUpdater.locationPlacemark)
                                    .padding()
                                Divider()
                                    .padding(.horizontal)
                                HourlyForcast(weather: $weatherUpdater.weather, hourlyWeather: $weatherUpdater.hourlyWeather)
                                    .padding()
                                Divider()
                                    .padding(.horizontal)
                                WeeklyForcast(weather: $weatherUpdater.weather)
                                    .padding()
                                Divider()
                                    .padding(.horizontal)
                                Bottom(weather: $weatherUpdater.weather, showSettings: $showSettings)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 12)
                                    .padding(.horizontal, 12)
                                Button(action: {
                                    guard let url = URL(string: "https://weatherkit.apple.com/legal-attribution.html") else {return}
                                    NSWorkspace.shared.open(url)
                                }){
                                    Text("Sourced from  Weather")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }.buttonStyle(.link)
                                    .padding(.bottom)
                            }
                            .frame(width: 400)
                        }
                        .frame(width: 400)
                    }else{
                        Spacer()
                        VStack{
                            Text("Two seconds...")
                                .font(.largeTitle)
                                .bold()
                            Text("We're fetching your current weather")
                                .font(.subheadline)
                                .bold()
                            ProgressView()
                            
                        }
                        .frame(width: 400, height: 400)
                        .padding()
                    }
                }else{
                    Spacer()
                    VStack{
                        Text("We're having some troubles")
                            .font(.largeTitle)
                            .bold()
                        Text("Make sure your WiFi and location services are on for this app.")
                            .font(.subheadline)
                            .bold()
                    }
                    .frame(width: 400, height: 400)
                    .padding()
                }
            }.task {
                weatherUpdater.fetchData()
            }
        }
    }
}


struct TaskId: Equatable{
    var location: CLLocation?
    var showIcon: Bool
    var currentWeather: CurrentWeather?
}

struct Top: View{
    
    @Binding var weather: Weather?
    @Binding var hourlyWeather: Forecast<HourWeather>?
    @Binding var locationPlacemark: CLPlacemark?
    
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    
    var body: some View{
        HStack(alignment: .center){
            VStack(alignment: .leading){
                Text(locationPlacemark!.locality ?? "Unknown")
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                Text(locationPlacemark!.country ?? "Unknown")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .opacity(0.6)
                Spacer()
                Text(weather!.currentWeather.condition.description)
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
            }.padding(.top, 8)
            Spacer()
            VStack(alignment: .trailing){
                HStack{
                    Text(localisedTemp(tempInCelsius: weather!.currentWeather.temperature.value, isCelsius: isCelsius))
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .onTapGesture {
                            isCelsius.toggle()
                        }
                    GetIcon(condition: weather!.currentWeather.condition, isDaylight: weather!.currentWeather.isDaylight)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 50)
                }
                Spacer()
                HStack(spacing:6){
                    Text("Feels like")
                    Text(localisedTemp(tempInCelsius: weather!.currentWeather.apparentTemperature.value, isCelsius: isCelsius))
                }
                .foregroundColor(.white)
                .font(.title3)
                .bold()
                .padding(.trailing, 7)
            }
        }
    }
}

// MARK: Hourly View
struct HourlyForcast: View{
    
    @Binding var weather: Weather?
    @Binding var hourlyWeather: Forecast<HourWeather>?
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    
    var body: some View{
        HStack(spacing: 20){
            ForEach((hourlyWeather?.forecast.prefix(7))!, id: \.self.date){ hour in
                HourlyForecastItem(time: hour.date, temp: localisedTemp(tempInCelsius: hour.temperature.value, isCelsius: isCelsius), weather: weather!, condition: hour.condition)
            }
        }
    }
}

struct HourlyForecastItem: View {
    
    var time: Date
    var temp: String
    var weather: Weather
    var condition: WeatherCondition
    @AppStorage("Is24Hours") var is24Hours: Bool = false
    
    var body: some View {
        VStack {
            Text(isCurrentHour ? NSLocalizedString("Now", comment: "") : formattedTime)
                .foregroundColor(.white)
                .font(.callout.monospacedDigit())
                .frame(maxWidth: .infinity)
            GetIcon(condition: condition, isDaylight: weather.currentWeather.isDaylight)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
            Text(temp)
                .foregroundColor(.white)
                .font(.callout.monospacedDigit())
                .frame(maxWidth: .infinity)
        }
    }
    
    var isCurrentHour: Bool {
        Calendar.current.component(.hour, from: Date()) == Calendar.current.component(.hour, from: time)
    }
    
    var formattedTime: String {
        is24Hours ? convertTo12HourFormat(time) : format24HourTime(time)
    }
    
    func convertTo12HourFormat(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: time).lowercased()
    }
    
    func format24HourTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
}


// MARK: Weekly View
struct WeeklyForcast: View{
    
    @Binding var weather: Weather?
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    
    var body: some View{
        VStack(spacing: 16){
            ForEach(weather!.dailyForecast.forecast.prefix(7), id: \.self.date){ day in
                WeeklyForcastItem(day: day.date.dayOfWeek(), tempHigh: localisedTemp(tempInCelsius: day.highTemperature.value, isCelsius: isCelsius), tempLow: localisedTemp(tempInCelsius: day.lowTemperature.value, isCelsius: isCelsius), condition: day.condition, weather: weather!)
            }
        }
    }
}
struct WeeklyForcastItem: View{
    
    var day: String
    var tempHigh: String
    var tempLow: String
    var condition: WeatherCondition
    var weather: Weather
    
    var body: some View{
        HStack{
            Text(Date().dayOfWeek() == day ? NSLocalizedString("Today", comment: "") : day)
                .foregroundColor(.white)
                .font(.headline)
                .bold()
            Spacer()
            Text(tempHigh)
                .foregroundColor(.white)
            Text(tempLow)
                .foregroundColor(.white)
                .opacity(0.6)
            GetIcon(condition: condition, isDaylight: weather.currentWeather.isDaylight)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
    }
}

// MARK: Extra Info
struct Bottom: View{
    
    @Binding var weather: Weather?
    @Binding var showSettings: Bool
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("Is24Hours") var is24Hours: Bool = false
    
    var body: some View{
        VStack(spacing: 16){
            HStack(spacing: 16) {
                VStack(spacing: 12) {
                    Text(weather!.currentWeather.uvIndex.value.description)
                        .foregroundColor(.white)
                        .bold()
                    Text("UV Index")
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .lineLimit(1)
                }
                VStack(spacing: 12) {
                    Text(weather!.currentWeather.dewPoint.value.description)
                        .foregroundColor(.white)
                        .bold()
                    Text("Dew Point")
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .lineLimit(1)
                }
                VStack(spacing: 12) {
                    Text("\(String(Int((Double(weather!.currentWeather.humidity.description) ?? 0.0)*100)))%")
                        .foregroundColor(.white)
                        .bold()
                    Text("Humidity")
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .lineLimit(1)
                }
                VStack(spacing: 12) {
                    Text(dateToTime(date: weather!.dailyForecast.first?.sun.sunrise, is24Hours: is24Hours))
                        .foregroundColor(.white)
                        .bold()
                    Text("Sunrise")
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .lineLimit(1)
                }
                VStack(spacing: 12) {
                    Text(dateToTime(date: weather!.dailyForecast.first?.sun.sunset, is24Hours: is24Hours))
                        .foregroundColor(.white)
                        .bold()
                    Text("Sunset")
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .lineLimit(1)
                    
                }
            }.minimumScaleFactor(0.5)
            
            
            HStack{
                Button(action: {
                    showSettings.toggle()
                }){
                    Text("Settings")
                }
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }){
                    Text("Quit")
                }
            }
        }
    }
}

func dateToTime(date: Date?, is24Hours: Bool) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = is24Hours ? "hh:mma" : "HH:mm"
    if let date = date{
        let currentTime = formatter.string(from: date)
        return currentTime
    }
    return ""
    
}

struct Preview: View{
    var body: some View{
        Text("Hello")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        //        MainView()
        Preview()
    }
}
