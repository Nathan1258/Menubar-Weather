//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 02/01/2023.
//

import SwiftUI
import LaunchAtLogin

enum MenuBarInfo: String, CaseIterable {
    case temperature = "Temperature"
    case feelslike = "Feels like temperature"
    case chanceOfPerception = "Chance of Perception"
}

struct SettingsView: View {
    
    @Binding var showSettings: Bool
    @AppStorage("showBackground") var showBackground: Bool = true
    @AppStorage("menuBarInfo") var menuBarInfo: MenuBarInfo = .temperature
    @AppStorage("IsCelsius") var isCelsius: Bool = true
    @AppStorage("showUnits") var showUnits: Bool = true
    @AppStorage("showIcon") var showIcon: Bool = true
//    @AppStorage("showFeelsLike") var showFeelsLike: Bool = false
    @AppStorage("Is24Hours") var is24Hours: Bool = false
    @AppStorage("monocromeIcon") var monocromeIcon: Bool = false

    
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
                Toggle("Show units when displaying temperature", isOn: $showUnits)
                Toggle("Use 12-hour time format", isOn: $is24Hours)
                Toggle("Show the current weather's icon aside the metric", isOn: $showIcon)
                Picker("Metric to display in menubar", selection: $menuBarInfo) {
                    ForEach(MenuBarInfo.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                    }
                }
//                Toggle("Show 'Feels like' temperature in the menu bar instead of actual temperature", isOn: $showFeelsLike)
                Toggle("Show monochrome icons", isOn: $monocromeIcon)
                Button(action: {
                    openURL("https://github.com/Nathan1258/Menubar-Weather")
                }){
                    Text("Go to GitHub Page")
                }
            }.padding()
            Spacer()
        }.frame(width: 400)
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        } else {
            print("Invalid URL")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}
