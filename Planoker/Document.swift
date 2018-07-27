//
//  Document.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/25/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Cocoa

internal final class Document: NSDocument {
	override init() {
	    super.init()
	}

	override class var autosavesInPlace: Bool {
		return true
	}

	override func makeWindowControllers() {
		// Returns the Storyboard that contains your Document window.
		let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
		let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
		self.addWindowController(windowController)
	}

	override func data(ofType typeName: String) throws -> Data {
		throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
	}

	override func read(from data: Data, ofType typeName: String) throws {
		throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
	}
}

