//
//  Document.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/25/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Cocoa

private enum EncodingErrors: String, Error {
	case UnexpectedInternalError = "Unexpected internal error"
	case DataDecodingError = "Error decoding data"
}

internal final class Document: NSDocument {
	private var deckSetWindowController: NSWindowController?

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
		deckSetWindowController = windowController
		self.addWindowController(windowController)
	}

	override func data(ofType typeName: String) throws -> Data {
		guard let viewController = deckSetWindowController?.contentViewController as? DeckSetCollectionViewController
			else { throw EncodingErrors.UnexpectedInternalError }
		return NSKeyedArchiver.archivedData(withRootObject: viewController.session)
	}

	override func read(from data: Data, ofType typeName: String) throws {
		guard let viewController = deckSetWindowController?.contentViewController as? DeckSetCollectionViewController
			else { throw EncodingErrors.UnexpectedInternalError }

		guard let session = NSKeyedUnarchiver.unarchiveObject(with: data) as AnyObject as? EstimationSession
			else { throw EncodingErrors.DataDecodingError }
		viewController.session = session
	}
}

