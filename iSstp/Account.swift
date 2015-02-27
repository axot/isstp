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
  
  override init() {}
  
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

  }

}