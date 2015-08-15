//
//  ViewController.swift
//  iSstp
//
//  Created by Zheng Shao on 2/26/15.
//  Copyright (c) 2015 axot. All rights reserved.
//

import Cocoa
import AppKit
import Foundation

class ViewController: NSViewController, NSTableViewDelegate {
  
  @IBOutlet dynamic var status: NSTextField!
  @IBOutlet weak var tableView: NSTableView!
  @IBOutlet var arrayController: NSArrayController!
  @IBOutlet weak var deleteBtn: NSButton!
  @IBOutlet weak var editBtn: NSButton!
  @IBOutlet weak var connectBtn: NSButton!
  
  dynamic var accounts : [Account] = []
  let ud = NSUserDefaults.standardUserDefaults()
  var statusTimer : NSTimer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    status.stringValue = "Not Connected!"
    if let data = ud.objectForKey("accounts") as? NSData {
      let unarc = NSKeyedUnarchiver(forReadingWithData: data)
      accounts = unarc.decodeObjectForKey("root") as! [Account]
    }
    
    tableView.setDelegate(self)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("stop:"), name: "All Stop", object: nil)
    
    let notif : NSNotification = NSNotification(name: "init", object:self)
    tableViewSelectionDidChange(notif)
  }
  
  func sstpStatus(){
    let result: NSString = runCommand("/sbin/ifconfig ppp0 | grep 'inet' | awk '{ print $2}'")
    
    if result.rangeOfString("ppp0").length == 0 && result.length != 0{
      status.stringValue = "Connected to server, your ip is: " + (result as String)
    }
  }
  
  @IBAction func saveConfig(sender: AnyObject) {
    ud.setObject(NSKeyedArchiver.archivedDataWithRootObject(accounts), forKey: "accounts")
    ud.synchronize()
  }
  
  @IBAction func connect(sender: AnyObject) {
    let ac = accounts[arrayController.selectionIndex]
    
    let qualityOfServiceClass = QOS_CLASS_BACKGROUND
    let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
    
    status.stringValue = "Try to connect " + ac.server! + "..."
      
    dispatch_async(backgroundQueue, {
      let task = NSTask()
      let base = NSBundle.mainBundle().resourcePath
      
      task.launchPath = base! + "/helper"
      
      task.arguments = []
      task.arguments.append("start")
      task.arguments.append(base! + "/sstpc")
      task.arguments.append(ac.user!)
      task.arguments.append(ac.pass!)
      task.arguments.append(ac.server!)
      task.arguments.append(ac.option!)
      task.arguments.reverse()
      
      let pipe = NSPipe()
      task.standardOutput = pipe
      task.launch()
      
      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
      
      print(output)
    })
    self.statusTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("sstpStatus"), userInfo: nil, repeats: true)
  }
  
  @IBAction func stop(sender: AnyObject) {
    if(self.statusTimer != nil)
    {
      self.statusTimer?.invalidate()
      self.statusTimer = nil
    }

    let qualityOfServiceClass = QOS_CLASS_BACKGROUND
    let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
    
    dispatch_async(backgroundQueue, {
      let task = NSTask()
      let base = NSBundle.mainBundle().resourcePath
      
      task.launchPath = base! + "/helper"
      
      task.arguments = []
      task.arguments.append("stop")
      task.arguments.reverse()
      
      let pipe = NSPipe()
      task.standardOutput = pipe
      task.launch()
      
      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
      
      print(output)
    })
    status.stringValue = "Not Connected!"
  }
  
  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }
  
  func runCommand(cmd: NSString) -> NSString {
    let task = NSTask()
    
    task.launchPath = "/bin/sh"
    
    task.arguments = []
    task.arguments.append("-c")
    task.arguments.append(cmd)
    task.arguments.reverse()
    
    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
    return output
  }
  
  @IBAction func deleteBtnPressed(sender: AnyObject) {
    arrayController.remove(sender);
    let notif : NSNotification = NSNotification(name: "delete", object:self)
    tableViewSelectionDidChange(notif)
  }
  
  func tableViewSelectionDidChange(notification: NSNotification){
    if (arrayController.selectionIndexes.count != 1){
      connectBtn.enabled = false
      editBtn.enabled = false
      deleteBtn.enabled = false
      return
    }
    connectBtn.enabled = true
    editBtn.enabled = true
    deleteBtn.enabled = true
  }
  
  override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "Advanced Options") {
      let optionViewController = segue.destinationController as! OptionViewController
      
      optionViewController.account = accounts[arrayController.selectionIndex]
      optionViewController.superViewController = self
    }
  }
}