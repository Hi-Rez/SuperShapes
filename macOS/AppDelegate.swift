//
//  AppDelegate.swift
//  YouiTwo-macOS
//
//  Created by Reza Ali on 2/5/21.
//

import Cocoa
import Forge

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var viewController: Forge.ViewController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let window = NSWindow(
            contentRect: NSRect(origin: CGPoint(x: 100.0, y: 400.0), size: CGSize(width: 512, height: 512)),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: true
        )
        self.window = window
        
        let viewController = Forge.ViewController(nibName: .init("ViewController"), bundle: Bundle(for: Forge.ViewController.self))
        viewController.renderer = Renderer()
        self.viewController = viewController
        
        guard let contentView = window.contentView else { return }
        
        let view = viewController.view
        view.frame = contentView.bounds
        view.autoresizingMask = [.width, .height]
        contentView.addSubview(view)
        
        window.setFrameAutosaveName("SuperShapes")
        window.titlebarAppearsTransparent = true
        window.title = ""
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

