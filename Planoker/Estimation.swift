//
//  Estimation.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/25/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Foundation

private enum Keys: String {
	case deckSet = "deck-set"
	case estimation = "estimation"
	case notes = "notes"
	case timestamp = "timestamp"
}

internal final class Estimation: NSObject, NSCoding {
	public let deckSetIdentifier: String
	public let estimationIdentifier: UInt16
	public let notes: String
	public let timestamp = Date()

	public init(deckSetIdentifier: String, estimationIdentifier: UInt16, notes: String) {
		self.deckSetIdentifier = deckSetIdentifier
		self.estimationIdentifier = estimationIdentifier
		self.notes = notes
	}

	public func encode(with aCoder: NSCoder) {
		aCoder.encode(deckSetIdentifier, forKey: Keys.deckSet.rawValue)
		aCoder.encode(estimationIdentifier, forKey: Keys.estimation.rawValue)
		aCoder.encode(notes, forKey: Keys.notes.rawValue)
		aCoder.encode(timestamp, forKey: Keys.timestamp.rawValue)
	}

	public required init?(coder aDecoder: NSCoder) {
		guard
			let deckSet = aDecoder.decodeObject(forKey: Keys.deckSet.rawValue) as? String,
			let notes = aDecoder.decodeObject(forKey: Keys.notes.rawValue) as? String,
			let timestamp = aDecoder.decodeObject(forKey: Keys.timestamp.rawValue) as? Date
			else { return nil }
		let estimationIdentifier = aDecoder.decodeInt32(forKey: Keys.estimation.rawValue)
		self.deckSetIdentifier = deckSet
		self.estimationIdentifier = UInt16(estimationIdentifier)
		self.notes = notes
		self.timestamp = timestamp
	}
}
