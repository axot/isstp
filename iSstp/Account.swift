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
  var display : String? = "Display"
  var user : String? = "Username"
  var pass : String? = "Password"
  var server : String? = "Server Name"
  
  var doesSkipCertWarn : String?
  var doesSkipCertWarnDefault : String? = "--cert-warn"

  var option : String?
  var defaultOption : String? = "usepeerdns require-mschap-v2 refuse-eap noauth noipdefault defaultroute"

  override init() {
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
    if let ret = self.display {
      aCoder.encodeObject(ret, forKey: "display")
    }
    
    if let ret = self.user {
      aCoder.encodeObject(ret, forKey: "user")
    }

    if let ret = self.pass {
      aCoder.encodeObject(ret, forKey: "pass")
    }

    if let ret = self.server {
      aCoder.encodeObject(ret, forKey: "server")
    }
    
    if let ret = self.doesSkipCertWarn {
      aCoder.encodeObject(ret, forKey: "doesSkipCertWarn")
    }
    
    if let ret = self.option {
      aCoder.encodeObject(ret, forKey: "option")
    }
  }
}