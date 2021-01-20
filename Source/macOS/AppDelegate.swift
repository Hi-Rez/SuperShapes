//
//  AppDelegate.swift
//  SuperShapes
//
//  Created by Reza Ali on 9/4/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var renderer = Renderer()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView().environmentObject(renderer)
               
        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}
