//
//  AppDelegate.swift
//  todolist
//
//  Created by Haseeb Amer on 6/1/2023.
//

import Cocoa
import Firebase
@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    override init() {
        FirebaseApp.configure()
    }
    
    var mainViewController : ViewController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
    
