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
    statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(20)
    let image: NSImage = NSImage(named: "statusbar_icon")!
    
    statusItem?.title = "Status Menu"
    statusItem?.image = image
    statusItem?.highlightMode = true
    statusItem?.menu = myMenu
  }
  
  func doScriptWithAdmin(inScript:String){
    let script = "do shell script \"/usr/bin/sudo /bin/sh \(inScript)\" with administrator privileges"
    var appleScript = NSAppleScript(source: script)
    var eventResult = appleScript!.executeAndReturnError(nil)
  }

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let base = NSBundle.mainBundle().resourcePath
    if NSFileManager.defaultManager().fileExistsAtPath(base! + "/installed") == false{
      doScriptWithAdmin(base! + "/install.sh")
    }
  }

  func applicationWillTerminate(aNotification: NSNotification) {
  }

  @IBAction func open(sender: NSMenuItem) {
    NSApplication.sharedApplication().unhide(self)
    NSApp.activateIgnoringOtherApps(true)
    NSNotificationCenter.defaultCenter().postNotificationName("Window Open", object: nil)
  }
  
  @IBAction func quit(sender: NSMenuItem) {
    NSNotificationCenter.defaultCenter().postNotificationName("All Stop", object: nil)
    NSApplication.sharedApplication().terminate(self)
  }
}
