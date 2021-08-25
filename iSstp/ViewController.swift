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

    @objc dynamic var accounts: [Account] = []
    let ud = UserDefaults.standard
    var statusTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        status.stringValue = "Not Connected!"
        if let data = ud.object(forKey: "accounts") as? Data {
            let unarc = NSKeyedUnarchiver(forReadingWith: data)
            accounts = unarc.decodeObject(forKey: "root") as! [Account]
        }

        tableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.stop(_:)), name: NSNotification.Name(rawValue: "All Stop"), object: nil)

        let notif: Notification = Notification(name: Notification.Name(rawValue: "init"), object:self)
        tableViewSelectionDidChange(notif)
    }

    @objc func sstpStatus() {
        let result: String = runCommand("/sbin/ifconfig ppp0 | grep 'inet' | awk '{ print $2}'")

        if result.range(of: "ppp0") == nil && result.count != 0 {
            status.stringValue = "Connected to server, your ip is: " + result
        } else {
            status.stringValue = "Not Connected!"
        }
    }

    @IBAction func saveConfig(_ sender: AnyObject) {
        ud.set(NSKeyedArchiver.archivedData(withRootObject: accounts), forKey: "accounts")
        ud.synchronize()
    }

    @IBAction func connect(_ sender: AnyObject) {
        let ac = accounts[arrayController.selectionIndex]

        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)

        status.stringValue = "Try to connect " + ac.server + "..."

        backgroundQueue.async(execute: {
            let task = Process()
            let base = Bundle.main.resourcePath

            task.launchPath = base! + "/helper"

            var sstpcPath = base! + "/sstpc"
            if self.ud.bool(forKey: "useExtSstpc") {
                sstpcPath = self.ud.string(forKey: "sstpcPath")!
            }

            task.arguments = [
                "start",
                sstpcPath + " " + ac.doesSkipCertWarn!,
                ac.user,
                "'" + ac.pass.replacingOccurrences(of: "'", with: "'\"'\"'") + "'",
                ac.server,
                ac.option!
            ]

            let pipe = Pipe()
            task.standardOutput = pipe
            task.launch()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

            if output.range(of: "server certificate failed") != nil {
                if (self.statusTimer != nil)
                {
                    self.statusTimer?.invalidate()
                    self.statusTimer = nil
                }

                self.status.stringValue = "Verification of server certificate failed"
            }

            print(output, terminator: "")
        })
        self.statusTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.sstpStatus), userInfo: nil, repeats: true)
    }

    @IBAction func stop(_ sender: AnyObject) {
        if (self.statusTimer != nil)
        {
            self.statusTimer?.invalidate()
            self.statusTimer = nil
        }

        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)

        backgroundQueue.async(execute: {
            let task = Process()
            let base = Bundle.main.resourcePath

            task.launchPath = base! + "/helper"

            task.arguments = ["stop"]

            let pipe = Pipe()
            task.standardOutput = pipe
            task.launch()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

            print(output, terminator: "")
        })
        status.stringValue = "Not Connected!"
    }

    func runCommand(_ cmd: String) -> String {
        let task = Process()

        task.launchPath = "/bin/sh"
        task.arguments = ["-c", cmd]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        return output
    }

    @IBAction func deleteBtnPressed(_ sender: AnyObject) {
        arrayController.remove(sender);
        let notif: Notification = Notification(name: Notification.Name(rawValue: "delete"), object:self)
        tableViewSelectionDidChange(notif)
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        if (arrayController.selectionIndexes.count != 1) {
            connectBtn.isEnabled = false
            editBtn.isEnabled = false
            deleteBtn.isEnabled = false
            return
        }
        connectBtn.isEnabled = true
        editBtn.isEnabled = true
        deleteBtn.isEnabled = true
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any!) {
        if (segue.identifier == "Advanced Options") {
            let optionViewController = segue.destinationController as! OptionViewController

            optionViewController.account = accounts[arrayController.selectionIndex]
            optionViewController.superViewController = self
        }
    }
}
