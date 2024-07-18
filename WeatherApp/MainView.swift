//
//  MainView.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 10/07/2024.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct MainView: View {
    
    @AppStorage("openWeather") var openWeather: Bool = false
    
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
    @AppStorage("showUnits") var showUnits: Bool = true
    @AppStorage("showIcon") var showIcon: Bool = true
    
    @AppStorage("openedBefore") var openedBefore: Bool = false
    @AppStorage("openWeatherAPIKey") var apiKey: String = ""
    
    @State var weatherAPIGuide: Bool = false
    @State var error: String = ""
    
    @State var previewNum: Int = 1
    
    var body: some View {
        if apiKey == ""{
            if weatherAPIGuide{
                Guide(weatherAPIGuide: $weatherAPIGuide)
            }else{
                WelcomeView(weatherAPIGuide: $weatherAPIGuide)
            }
        }else{
            OpenWeatherView()
                .environmentObject(locationManager)
                .environmentObject(weatherUpdater)
        }
    }
}

struct WelcomeView: View {
    
    @Binding var weatherAPIGuide: Bool
    
    var body: some View{
        VStack{
            Image("mostlyclear")
                .resizable()
                .frame(width: 100, height: 75)
            Text("Welcome to Menubar Weather")
                .font(.largeTitle)
                .bold()
            Text("Menubar Weather is a free, open source app with the option to integrate with Apple Weather for a small fee to cover API costs.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .bold()
                .padding(.bottom)
            Text("You may either use your own Weather API's key which gives you free access to a 3-day realtime weather forecast or download the app from the App store and pay a small fee to use Apple Weather which will give you access to a 7-day realtime weather forecast and extra features.")
                .font(.callout)
                .multilineTextAlignment(.center)
            
            VStack{
                Button(action: {
                    weatherAPIGuide.toggle()
                }){
                    Text("Guide me to use this app for free")
                }
                .background(.white)
                .cornerRadius(4)
                
                Button(action: {
                    if let url = URL(string: "https://apps.apple.com/gb/app/menubar-weather/id1662381447") {
                        NSWorkspace.shared.open(url)
                    }
                }){
                    Text("Install App Store version and use Apple Weather")
                }
                .background(Color.white)
                .cornerRadius(4)
            }
        }
        .frame(width: 400, height: 400)
        .padding(.horizontal)
    }
}

struct Guide: View{
    
    @Binding var weatherAPIGuide: Bool
    @AppStorage("openedBefore") var openedBefore: Bool = false
    @AppStorage("openWeatherAPIKey") var apiKey: String = ""
    @AppStorage("openWeather") var openWeather: Bool = false
    
    var body: some View{
        VStack(alignment: .leading){
            HStack(alignment: .center){
                Button(action: {
                    weatherAPIGuide.toggle()
                }){
                    Image(systemName: "chevron.left")
                }
                Text("Weather API Guide")
                    .font(.largeTitle)
                    .bold()
            }
            Text("Please note: This service is a third-party hence the accuracy and privacy can not be guaranteed")
                .font(.callout)
            Spacer()
            VStack(spacing: 12){
                Text("Weather API is a third-party service that you can integrate in this app to get free 3-day weather forecast.")
                    .multilineTextAlignment(.leading)
                    .font(.callout)
                VStack(alignment: .leading){
                    Text("Step 1.").bold()
                    HStack(spacing: 2){
                        Text("Create an account at")
                        Text("Weather API")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                if let url = URL(string: "https://www.weatherapi.com/signup.aspx") {
                                    NSWorkspace.shared.open(url)
                                }
                            }
                        Spacer()
                    }
                }
                VStack(alignment: .leading){
                    Text("Step 2.").bold()
                    HStack(spacing: 2){
                        Text("Go to your")
                        Text("account page")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                if let url = URL(string: "https://www.weatherapi.com/my/") {
                                    NSWorkspace.shared.open(url)
                                }
                            }
                        Text("once signed up.")
                        Spacer()
                    }
                }
                VStack(alignment: .leading){
                    Text("Step 3.").bold()
                    HStack(spacing: 2){
                        Text("Fetch your API Key from this page which should be around 31 characters long and paste below:")
                        Spacer()
                    }
                }
                TextField("API Key", text: $apiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocorrectionDisabled()
                    .disableAutocorrection(true)
                Button(action: {
                    openWeather = true
                    weatherAPIGuide = false
                    openedBefore = true
                }){
                    Text("Submit key")
                }
                .background(Color.white)
                .cornerRadius(4)
                Spacer()
            }
        }
        .frame(width: 400, height: 400)
        .padding()
    }
}

