//
//  DeckSetCollectionViewController.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/25/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Cocoa

class DeckSetCollectionViewController: NSViewController {
	private let collectionViewDataSource = DeckSetCollectionViewDataSource()
	private let collectionViewDelegate = DeckSetCollectionViewDelegate()

	public var session = EstimationSession()

	@IBOutlet public var collectionView: NSCollectionView? {
		didSet {
			collectionView?.dataSource = collectionViewDataSource
			collectionView?.delegate = collectionViewDelegate
		}
	}

	@IBAction public func reveal(_ sender: AnyObject?) {
		guard
			let selectedIndexes = collectionView?.selectionIndexes,
			let firstIndex = selectedIndexes.first,
			let deckSet = representedObject as AnyObject as? DeckSet
		else { return }

		let selectedEstimation = deckSet.possibleEstimations[firstIndex]
		let estimation = Estimation(deckSetIdentifier: deckSet.identifier, estimationIdentifier: selectedEstimation.identifier, notes: "")
		session.estimations.append(estimation)

		// TODO: Add reveal UI
	}

	@IBAction public func hide(_ sender: AnyObject?) {
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		representedObject = ConventionalDeckSet()
	}

	override var representedObject: Any? {
		didSet {
			collectionViewDataSource.deckSet = representedObject as AnyObject as? DeckSet
			collectionView?.reloadData()
		}
	}
}

