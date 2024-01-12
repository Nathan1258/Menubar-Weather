//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 02/01/2023.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    
    @Binding var showSettings: Bool
    @AppStorage("showBackground") var showBackground: Bool = true
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("showIcon") var showIcon: Bool = true
    @AppStorage("Is24Hours") var is24Hours: Bool = false
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 12){
                HStack{
                    Button(action: {
                        showSettings.toggle()
                    }){
                        Image(systemName: "chevron.left")
                    }
                    Text("Settings")
                        .font(.largeTitle)
                        .bold()
                }
                LaunchAtLogin.Toggle{
                    Text("Launch MenuBar Weather at login")
                }
                Toggle("Show gradient background based on current weather", isOn: $showBackground)
                Toggle("Use Celsius instead of Fahrenheit", isOn: $isCelsius)
                Toggle("Use 12-hour time format", isOn: $is24Hours)
                Toggle("Show a weather icon aside the temperature", isOn: $showIcon)
            }.padding()
            Spacer()
        }.frame(width: 400)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}
