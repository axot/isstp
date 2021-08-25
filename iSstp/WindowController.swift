//
//  WindowController.swift
//  iSstp
//
//  Created by Zheng Shao on 2/26/15.
//  Copyright (c) 2015 axot. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func awakeFromNib() {
        window!.collectionBehavior = NSWindow.CollectionBehavior.canJoinAllSpaces
        NotificationCenter.default.addObserver(self, selector: #selector(WindowController.reopen), name: NSNotification.Name(rawValue: "Window Open"), object: nil)
    }

    @objc func reopen() {
        window!.orderFront(self)
        window!.makeKeyAndOrderFront(self)
    }
}
