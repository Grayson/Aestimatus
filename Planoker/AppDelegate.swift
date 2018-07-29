//
//  AppDelegate.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/25/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	private var displayWindowController: NSWindowController?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
		displayWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DisplayWindow")) as? NSWindowController
		displayWindowController?.showWindow(self)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
	}
}

