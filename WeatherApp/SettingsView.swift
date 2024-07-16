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
    @AppStorage("Is24Hours") var is24Hours: Bool = false
    @AppStorage("monocromeIcon") var monocromeIcon: Bool = false
    @AppStorage("openWeatherAPIKey") var apiKey: String = ""
    @AppStorage("openWeather") var openWeather: Bool = false
    
    @AppStorage("customLocations") private var locationsData: String = "[]"
    var locations: [String] {
        get {
            let data = Data(locationsData.utf8)
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            locationsData = String(data: data ?? Data(), encoding: .utf8) ?? "[]"
        }
    }

    @State private var selectedLocation: String? = nil
    @State private var newLocation: String = ""

    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 12){
                HStack{
                    Button(action: {
                        showSettings.toggle()
                    }){
                        Image(systemName: "chevron.left")
                    }
                    HStack{
                        Text("Settings")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        Button(action: {
                            openURL("https://github.com/Nathan1258/Menubar-Weather")
                        }){
                            Text("Go to GitHub Page")
                        }
                    }
                }
                Group{
                    Text("General")
                        .font(.title)
                    LaunchAtLogin.Toggle{ Text("Launch MenuBar Weather at login")}
                    Toggle("Use 12-hour time format", isOn: $is24Hours)
                    Toggle("Show monochrome icons", isOn: $monocromeIcon)
                }
                Group{
                    Text("Customisation")
                        .font(.title)
                    Toggle("Show gradient background based on current weather", isOn: $showBackground)
                    Toggle("Use Celsius instead of Fahrenheit", isOn: $isCelsius)
                    Toggle("Show units when displaying temperature", isOn: $showUnits)
                    Toggle("Show the current weather's icon aside the metric", isOn: $showIcon)
                    Picker("Metric to display in menubar", selection: $menuBarInfo) {
                        ForEach(MenuBarInfo.allCases, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                }
                Group{
                    Text("Custom Weather provider")
                        .font(.title)
//                    Text("Using your own Weather API key will allow you to manually specify multiple locations.")
//                        .multilineTextAlignment(.leading)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .font(.callout)
                    Text("Note: Using your own key will disable Apple Weather integration and you will only get a 3 day forcast opposed to 7 unless you get a paid key. If you have an active subscription for Apple Weather integration then you will need to manually cancel that within your App Store Settings.")
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption)
                    Toggle("Use custom Weather API key", isOn: $openWeather)
                    if openWeather{
                        SecureField(text: $apiKey, label: {
                            Text("Open Weather API Key")
                        })
                        Button(action: {
                            openWeather = false
                        }){
                            Text("Subscribe for Apple Weather Integration")
                        }
//                        Text("Locations")
//                            .font(.title)
//                        LocationSelection(locations: locations, selectedLocation: $selectedLocation, newLocation: $newLocation)
                    }
                }
                Spacer()
            }.padding()
        }.frame(width: 400)
        .frame(minHeight: 500)
    }
    
    private mutating func addLocation() {
        guard !newLocation.isEmpty else { return }
        locations.append(newLocation)
        newLocation = ""
    }
    
    private mutating func removeSelectedLocation() {
        guard let selected = selectedLocation else { return }
        locations.removeAll { $0 == selected }
        selectedLocation = nil
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        } else {
            print("Invalid URL")
        }
    }
}

struct LocationSelection: View {
    
    
    @State var locations: [String]
    @Binding var selectedLocation: String?
    @Binding var newLocation: String
    
    var body: some View {
        VStack{
            List(selection: $selectedLocation){
                ForEach(locations, id: \.self) { location in
                    Text(location)
                        .font(.callout)
                }
                TextField("Add a new location", text: $newLocation, onCommit: {
                    newLocation = ""
                    addLocation()
                })
            }
            .background(.clear)
            HStack(spacing: 0) {
                Button(action: {
                    addLocation()
                    newLocation = ""
                }) {
                    Image(systemName: "plus")
                        .resizable()
                }.buttonStyle(BorderlessButtonStyle())
                .frame(width: 20, height: 20)
                Divider()
                Button(action: {
                    removeSelectedLocation()
                }) {
                    Image(systemName: "minus")
                        .resizable()
                }.buttonStyle(BorderlessButtonStyle())
                .frame(width: 20, height: 20)
                Divider()
                Spacer()
            }.frame(height: 20)
        }
    }
    
    private func addLocation() {
        guard !newLocation.isEmpty else { return }
        if locations.contains(newLocation) {return}
        locations.append(newLocation)
        newLocation = ""
    }
    
    private func removeSelectedLocation() {
        guard let selected = selectedLocation else { return }
        locations.removeAll { $0 == selected }
        selectedLocation = nil
    }
}

