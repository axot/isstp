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
    var display: String = "Display"
    var user: String = "Username"
    var pass: String = "Password"
    var server: String = "Server Name"

    var doesSkipCertWarn: String?
    var doesSkipCertWarnDefault: String = "--cert-warn"

    var option: String?
    var defaultOption: String = "usepeerdns require-mschap-v2 refuse-eap noauth noipdefault defaultroute"

    override init() {
        doesSkipCertWarn = doesSkipCertWarnDefault
        option = defaultOption
    }

    required init(coder aDecoder: NSCoder) {
        if let ret = aDecoder.decodeObject(forKey: "display") as? String {
            self.display = ret
        }

        if let ret = aDecoder.decodeObject(forKey: "user") as? String {
            self.user = ret
        }

        if let ret = aDecoder.decodeObject(forKey: "pass") as? String {
            self.pass = ret
        }

        if let ret = aDecoder.decodeObject(forKey: "server") as? String {
            self.server = ret
        }

        if let ret = aDecoder.decodeObject(forKey: "doesSkipCertWarn") as? String {
            self.doesSkipCertWarn = ret
        } else {
            self.doesSkipCertWarn = doesSkipCertWarnDefault
        }

        if let ret = aDecoder.decodeObject(forKey: "option") as? String {
            self.option = ret
        } else {
            self.option = defaultOption
        }
    }

    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(self.display, forKey: "display")

        aCoder.encode(self.user, forKey: "user")

        aCoder.encode(self.pass, forKey: "pass")

        aCoder.encode(self.server, forKey: "server")

        aCoder.encode(self.doesSkipCertWarn, forKey: "doesSkipCertWarn")

        aCoder.encode(self.option, forKey: "option")
    }
}
