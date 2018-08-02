//
//  DeckSet.swift
//  Aestimatus
//
//  Created by Grayson Hansard on 7/25/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Foundation

protocol DeckSet {
	var possibleEstimations: [PossibleEstimation] { get }
	var identifier: String { get }
}
