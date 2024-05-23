//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 31/12/2022.
//

import SwiftUI
import CoreLocation
import WeatherKit

@main
struct WeatherAppApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var menuTitle: String = "..."
    @State var menuImage: String = "hourglass"
    var body: some Scene {
        WindowGroup{
            MainView()
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate{
    
    static var shared: AppDelegate!
    
    
    var statusItem: NSStatusItem?
    var popOver = NSPopover()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        precondition(AppDelegate.shared == nil)
        AppDelegate.shared = self
        
        let mainView = MainView()
        
        
        popOver.behavior = .transient
        popOver.animates = true
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: mainView)
        
        popOver.contentViewController?.view.window?.makeKey()
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.imagePosition = NSControl.ImagePosition.imageLeft
        if let MenuButton = statusItem?.button{
            MenuButton.title = "..."
            MenuButton.image = NSImage(systemSymbolName: "hourglass", accessibilityDescription: "")
            MenuButton.action = #selector(MenuButtonToggle)
        }
        
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
    }
    
    @objc func MenuButtonToggle(sender: AnyObject? = nil){
        
        @Environment(\.openURL) var openURL
        
        if popOver.isShown{
            popOver.performClose(sender)
        }
        else{
            if let menuButton = statusItem?.button{
                NSApplication.shared.activate(ignoringOtherApps: true)
                self.popOver.contentSize = NSSize(width: 400, height: 300)
                self.popOver.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .minY)
            }
        }
    }
    
    @objc func closePopover(_ sender: AnyObject? = nil) {
        popOver.performClose(sender)
    }
}
