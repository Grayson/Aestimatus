//
//  EstimationSession.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/25/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Foundation

internal final class EstimationSession: NSObject, NSCoding {
	public var estimations: [Estimation] = []
	private let start: Date

	public override init() {
		start = Date()
	}

	public func encode(with aCoder: NSCoder) {
		aCoder.encode(estimations, forKey: "estimations")
		aCoder.encode(start, forKey: "start")
	}

	public init?(coder aDecoder: NSCoder) {
		guard
			let estimations = aDecoder.decodeObject(forKey: "estimations") as? [Estimation],
			let start = aDecoder.decodeObject(forKey: "start") as? Date
			else { return nil }
		self.estimations = estimations
		self.start = start
	}
}
