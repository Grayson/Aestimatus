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

	private lazy var displayWindowController: NSWindowController = {
		let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
		return storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DisplayWindow")) as! NSWindowController
	}()

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
			let deckSet = representedObject as AnyObject as? DeckSet,
			let displayController = displayWindowController.contentViewController as? DisplayWindowViewController
		else { return }

		let selectedEstimation = deckSet.possibleEstimations[firstIndex]
		let estimation = Estimation(deckSetIdentifier: deckSet.identifier, estimationIdentifier: selectedEstimation.identifier, notes: "")
		session.estimations.append(estimation)

		displayController.showEstimation(selectedEstimation)
	}

	@IBAction func toggleVideo(_ sender: Any) {
		guard let displayController = displayWindowController.contentViewController as? DisplayWindowViewController else { return }
		if displayController.isCapturingVideo {
			displayController.stopCapture()
		}
		else {
			displayController.startCapture()
		}
	}

	@IBAction public func hide(_ sender: AnyObject?) {
		guard let displayController = displayWindowController.contentViewController as? DisplayWindowViewController else { return }
		displayController.removeFromStage()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		representedObject = ConventionalDeckSet()
		displayWindowController.showWindow(self)

		guard let displayController = displayWindowController.contentViewController as? DisplayWindowViewController else { return }
		collectionViewDelegate.selectionChanged = { [weak self] view in
			let selectedIndexes = view.selectionIndexes
			guard
				let firstIndex = selectedIndexes.first,
				let deckSet = self?.representedObject as AnyObject as? DeckSet
			else {
				displayController.removeFromStage()
				return
			}
			displayController.removeFromStage()
			displayController.placeOnStage(deckSet.possibleEstimations[firstIndex])
		}
	}

	override var representedObject: Any? {
		didSet {
			collectionViewDataSource.deckSet = representedObject as AnyObject as? DeckSet
			collectionView?.reloadData()
		}
	}
}

