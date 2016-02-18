//
//  OptionViewController.swift
//  iSstp
//
//  Created by Zheng Shao on 8/15/15.
//  Copyright (c) 2015 axot. All rights reserved.
//

import Cocoa
import AppKit
import Foundation

class OptionViewController: NSViewController, NSTableViewDelegate {
  var account : Account?
  var superViewController : ViewController?

  @IBOutlet weak var optionText: NSTextField!
  @IBOutlet weak var doesSkipCertWarn: NSButton!
  
  override func viewWillAppear() {
    preferredContentSize = self.view.frame.size
    optionText.stringValue = account!.option!

    if (account?.doesSkipCertWarn?.characters.count > 0){
      doesSkipCertWarn.state = NSOnState
    }
    else{
      doesSkipCertWarn.state = NSOffState
    }
  }
  
  @IBAction func saveBtnPressed(sender: AnyObject) {
    account?.option = optionText.stringValue
    
    if (doesSkipCertWarn.state == NSOffState){
      account?.doesSkipCertWarn = ""
    }
    else{
      account?.doesSkipCertWarn = account!.doesSkipCertWarnDefault
    }
    
    superViewController!.saveConfig(self)
    dismissController(self)
  }
  
  @IBAction func resetBtnPressed(sender: AnyObject) {
    optionText.stringValue = account!.defaultOption
    doesSkipCertWarn.state = NSOnState
  }  
}