//
//  ConventionalDeckSet.swift
//  Aestimatus
//
//  Created by Grayson Hansard on 7/25/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Foundation

internal struct ConventionalDeckSet: DeckSet {
	let possibleEstimations: [PossibleEstimation] = [
		PossibleEstimation(display: "0", relativeRank: 0, identifier: 0),
		PossibleEstimation(display: "½", relativeRank: 1, identifier: 1),
		PossibleEstimation(display: "1", relativeRank: 2, identifier: 2),
		PossibleEstimation(display: "2", relativeRank: 3, identifier: 3),
		PossibleEstimation(display: "3", relativeRank: 4, identifier: 4),
		PossibleEstimation(display: "5", relativeRank: 5, identifier: 5),
		PossibleEstimation(display: "8", relativeRank: 6, identifier: 6),
		PossibleEstimation(display: "13", relativeRank: 7, identifier: 7),
		PossibleEstimation(display: "20", relativeRank: 8, identifier: 8),
		PossibleEstimation(display: "40", relativeRank: 9, identifier: 9),
		PossibleEstimation(display: "100", relativeRank: 10, identifier: 10),
		PossibleEstimation(display: "∞", relativeRank: 11, identifier: 11),
	]

	let identifier: String = "conventional"
}
