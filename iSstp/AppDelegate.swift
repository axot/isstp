//
//  AppDelegate.swift
//  iSstp
//
//  Created by Zheng Shao on 2/26/15.
//  Copyright (c) 2015 axot. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet dynamic var myMenu: NSMenu!
    var statusItem: NSStatusItem?

    override func awakeFromNib()
    {
        statusItem = NSStatusBar.system.statusItem(withLength: 20)
        let image: NSImage = NSImage(named: "statusbar_icon")!

        statusItem?.title = "Status Menu"
        statusItem?.image = image
        statusItem?.highlightMode = true
        statusItem?.menu = myMenu
    }

    func doScriptWithAdmin(_ inScript:String) {
        let script = "do shell script \"/usr/bin/sudo /bin/sh \(inScript)\" with administrator privileges"
        let appleScript = NSAppleScript(source: script)
        appleScript!.executeAndReturnError(nil)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let ud = UserDefaults.standard
        let dafaults: [String: Any] = [
            "useExtSstpc": false,
            "sstpcPath": "/usr/local/sbin/sstpc"
        ]
        ud.register(defaults: dafaults)

        let base = Bundle.main.resourcePath
        if FileManager.default.fileExists(atPath: base! + "/installed") == false {
            doScriptWithAdmin(base! + "/install.sh")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    @IBAction func open(_ sender: NSMenuItem) {
        NSApplication.shared.unhide(self)
        NSApp.activate(ignoringOtherApps: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Window Open"), object: nil)
    }

    @IBAction func quit(_ sender: NSMenuItem) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "All Stop"), object: nil)
        NSApplication.shared.terminate(self)
    }
}
