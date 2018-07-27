//
//  Session.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/25/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Foundation

internal final class Session: NSCoding {
	public let estimations: [Estimation]

	public func encode(with aCoder: NSCoder) {
		aCoder.encode(estimations, forKey: "estimations")
	}

	public init?(coder aDecoder: NSCoder) {
		guard let estimations = aDecoder.decodeObject(forKey: "estimations") as? [Estimation]
			else { return nil }
		self.estimations = estimations
	}
}
