//
//  OpenWeatherView.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 10/07/2024.
//

import SwiftUI
import CoreLocation

struct OpenWeatherView: View {
    @State var showSettings: Bool = false
    @AppStorage("showBackground") var showBackground: Bool = true
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("showIcon") var showIcon: Bool = true
    @State var error: String = ""
    
    @State var previewNum: Int = 1
    
    @EnvironmentObject var weatherUpdater: WeatherUpdater
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        if showSettings{
            SettingsView(showSettings: $showSettings)
        }else{
            VStack{
                if !weatherUpdater.errorCustomWeather{
                    if let weather = weatherUpdater.CustomWeather, let _ = weatherUpdater.CustomWeather?.forecast.forecastday.first?.hour, let _ = weatherUpdater.locationPlacemark{
                        ZStack{
                            if showBackground{
                                GetBackgroundCustomWeather(condition: weatherUpdater.CustomWeather?.current.condition.text ?? "", isDaylight: (weatherUpdater.CustomWeather?.current.isDay != 0)).ignoresSafeArea()
                            }
                            VStack{
                                TopCustomWeather(weather: $weatherUpdater.CustomWeather, locationPlacemark: $weatherUpdater.locationPlacemark)
                                    .padding()
                                Divider()
                                    .padding(.horizontal)
                                HourlyForecastCustomWeather(hourlyWeatherCurrentDay: weather.forecast.forecastday.first!, hourlyWeatherNextDay: weather.forecast.forecastday[2])
                                    .padding()
                                Divider()
                                    .padding(.horizontal)
                                WeeklyForecastCustomWeather(dailyForcast: weather.forecast)
                                    .padding()
                                Divider()
                                    .padding(.horizontal)
                                BottomCustomWeather(weather: weather.current, astro: weather.forecast.forecastday.first?.astro, showSettings: $showSettings)
                                    .padding()
                                Button(action: {
                                    guard let url = URL(string: "https://www.weatherapi.com/") else {return}
                                    NSWorkspace.shared.open(url)
                                }){
                                    Text("Sourced from Weather API")
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
                        Text("Make sure your WiFi and location services are on for this app and check your API key is correct in settings.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .bold()
                        Button(action: {
                            showSettings.toggle()
                        }){
                            Text("Settings")
                        }
                    }
                    .frame(width: 400, height: 400)
                    .padding()
                }
            }
            .task {
                weatherUpdater.fetchData()
            }
        }
    }
}

struct TopCustomWeather: View {
    @Binding var weather: CustomWeatherModel?
    @Binding var locationPlacemark: CLPlacemark?
    
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("showUnits") var showUnits: Bool = true
    
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
                Text(customWeatherToReadableCondition(condition: weather?.current.condition.text ?? "Unknown"))
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
            }.padding(.top, 8)
            Spacer()
            VStack(alignment: .trailing){
                HStack{
                    Text(localisedTemp(tempInCelsius: weather?.current.tempC.magnitude ?? 0.0, isCelsius: isCelsius, showUnits: showUnits))
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .onTapGesture {
                            isCelsius.toggle()
                        }
                    GetCustomWeatherIcon(condition: weather?.current.condition.text ?? "Unknown", isDaylight: true)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 50)
                        .onTapGesture {
                            let weatherAppURL = URL(fileURLWithPath: "/System/Applications/Weather.app")
                            NSWorkspace.shared.open(weatherAppURL)
                        }
                }
                Spacer()
                HStack(spacing:6){
                    Text("Feels like")
                    Text(localisedTemp(tempInCelsius: weather?.current.feelslikeC.magnitude ?? 0.0, isCelsius: isCelsius, showUnits: showUnits))
                }
                .foregroundColor(.white)
                .font(.title3)
                .bold()
                .padding(.trailing, 7)
            }
        }
    }
}

extension Int {
    var dateFromEpoch: Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}

// MARK: Hourly View
struct HourlyForecastCustomWeather: View {
    var hourlyWeatherCurrentDay: Forecastday
    var hourlyWeatherNextDay: Forecastday
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("showUnits") var showUnits: Bool = true
    
    var body: some View {
        let currentDate = Date()
        let combinedHours = hourlyWeatherCurrentDay.hour + hourlyWeatherNextDay.hour
        
        HStack(spacing: 20) {
            ForEach(filteredHours(currentDate: currentDate, combinedHours: combinedHours).prefix(7), id: \.timeEpoch) { hour in
                if let timeEpoch = hour.timeEpoch {
                    HourlyForecastItemCustomWeather(
                        time: timeEpoch.dateFromEpoch,
                        temp: localisedTemp(tempInCelsius: hour.tempC, isCelsius: isCelsius, showUnits: showUnits),
                        condition: hour.condition.text,
                        isDaylight: hour.isDay != 0
                    )
                }
            }
        }
    }
    
    func filteredHours(currentDate: Date, combinedHours: [Current]) -> [Current] {
        combinedHours.filter {
            guard let hourEpoch = $0.timeEpoch else { return false }
            let hourDate = Date(timeIntervalSince1970: TimeInterval(hourEpoch))
            let hoursDifference = Calendar.current.dateComponents([.hour], from: currentDate, to: hourDate).hour ?? 0
            return hoursDifference >= 0
        }
    }
}





extension Int {
    func currentHourFromEpoch() -> Int {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let calendar = Calendar.current
        return calendar.component(.hour, from: date)
    }
}

struct HourlyForecastItemCustomWeather: View {
    
    var time: Date
    var temp: String
    var condition: String
    var isDaylight: Bool
    @AppStorage("Is24Hours") var is24Hours: Bool = false
    
    var body: some View {
        VStack {
            Text(isCurrentHour ? NSLocalizedString("Now", comment: "") : formattedTime)
                .foregroundColor(.white)
                .font(.callout.monospacedDigit())
                .frame(maxWidth: .infinity)
            GetCustomWeatherIcon(condition: condition, isDaylight: isDaylight)
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
struct WeeklyForecastCustomWeather: View{
    
    var dailyForcast: ForecastC?
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("showUnits") var showUnits: Bool = true
    
    var body: some View{
        VStack(spacing: 16){
            ForEach(dailyForcast!.forecastday, id: \.self.date){ day in
                WeeklyForcastItemCustomWeather(day: day.dateEpoch.dayOfWeekFromEpoch(), tempHigh: localisedTemp(tempInCelsius: day.day.maxtempC, isCelsius: isCelsius, showUnits: showUnits), tempLow: localisedTemp(tempInCelsius: day.day.mintempC, isCelsius: isCelsius, showUnits: showUnits), condition: day.day.condition.text)
            }
        }
    }
}
extension Int {
    func dayOfWeekFromEpoch() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}
struct WeeklyForcastItemCustomWeather: View{
    
    var day: String
    var tempHigh: String
    var tempLow: String
    var condition: String
    
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
            GetCustomWeatherIcon(condition: condition, isDaylight: true)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
    }
}

// MARK: Extra Info
struct BottomCustomWeather: View{
    
    var weather: Current?
    var astro: Astro?
    @Binding var showSettings: Bool
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("Is24Hours") var is24Hours: Bool = false
    @AppStorage("showUnits") var showUnits: Bool = true
    
    var body: some View{
        VStack(spacing: 16){
            HStack(spacing: 16) {
                VStack(spacing: 12) {
                    Text(String(weather?.uv ?? 0))
                        .foregroundColor(.white)
                        .bold()
                    Text("UV Index")
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .lineLimit(1)
                }
                VStack(spacing: 12) {
                    Text(String(weather?.dewpointC ?? 0))
                        .foregroundColor(.white)
                        .bold()
                    Text("Dew Point")
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .lineLimit(1)
                }
                VStack(spacing: 12) {
                    Text("\(String(weather?.humidity ?? 0))%")
                        .foregroundColor(.white)
                        .bold()
                    Text("Humidity")
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .lineLimit(1)
                }
                VStack(spacing: 12) {
                    Text(astro?.sunrise ?? "nil")
                        .foregroundColor(.white)
                        .bold()
                    Text("Sunrise")
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .lineLimit(1)
                }
                VStack(spacing: 12) {
                    Text(astro?.sunset  ?? "nil")
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
