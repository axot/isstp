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
  
  override func viewWillAppear() {
    preferredContentSize = self.view.frame.size
    optionText.stringValue = account!.option!
  }
  
  @IBAction func saveBtnPressed(sender: AnyObject) {
    account?.option = optionText.stringValue
    superViewController!.saveConfig(self)
    dismissController(self)
  }
  
  @IBAction func resetBtnPressed(sender: AnyObject) {
    optionText.stringValue = account!.defaultOption!
  }  
}