//
//  Account.swift
//  iSstp
//
//  Created by Zheng Shao on 2/26/15.
//  Copyright (c) 2015 axot. All rights reserved.
//

import Foundation

@objc(Account)
class Account: NSObject {
  var display : String = "Display"
  var user : String = "Username"
  var pass : String = "Password"
  var server : String = "Server Name"
  
  var doesSkipCertWarn : String?
  var doesSkipCertWarnDefault : String = "--cert-warn"

  var option : String?
  var defaultOption : String = "usepeerdns require-mschap-v2 refuse-eap noauth noipdefault defaultroute"

  override init() {
    doesSkipCertWarn = doesSkipCertWarnDefault
    option = defaultOption
  }
  
  required init(coder aDecoder: NSCoder) {
    if let ret = aDecoder.decodeObjectForKey("display") as? String {
      self.display = ret
    }
    
    if let ret = aDecoder.decodeObjectForKey("user") as? String {
      self.user = ret
    }
    
    if let ret = aDecoder.decodeObjectForKey("pass") as? String {
      self.pass = ret
    }
    
    if let ret = aDecoder.decodeObjectForKey("server") as? String {
      self.server = ret
    }

    if let ret = aDecoder.decodeObjectForKey("doesSkipCertWarn") as? String {
      self.doesSkipCertWarn = ret
    }else{
      self.doesSkipCertWarn = doesSkipCertWarnDefault
    }
    
    if let ret = aDecoder.decodeObjectForKey("option") as? String {
      self.option = ret
    }else{
      self.option = defaultOption
    }
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.display, forKey: "display")

    aCoder.encodeObject(self.user, forKey: "user")

    aCoder.encodeObject(self.pass, forKey: "pass")

    aCoder.encodeObject(self.server, forKey: "server")
    
    aCoder.encodeObject(self.doesSkipCertWarn, forKey: "doesSkipCertWarn")
    
    aCoder.encodeObject(self.option, forKey: "option")
  }
}