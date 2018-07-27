//
//  ViewController.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/25/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	private let collectionViewDataSource = DeckSetCollectionViewDataSource()
	private let collectionViewDelegate = DeckSetCollectionViewDelegate()

	@IBOutlet public var collectionView: NSCollectionView? {
		didSet {
			collectionView?.dataSource = collectionViewDataSource
			collectionView?.delegate = collectionViewDelegate
		}
	}

	@IBAction public func reveal(_ sender: AnyObject?) {
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

