//
//  CardCollectionViewItem.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/26/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Cocoa

internal final class CardCollectionViewItem: NSCollectionViewItem {
	private static let selectedBorderColor = NSColor.selectedControlColor
	private static let normalBorderColor = NSColor.controlBackgroundColor

	@IBOutlet public var cardView: BasicCardView?

	override func awakeFromNib() {
		cardView?.borderTopColor = CardCollectionViewItem.normalBorderColor
	}

	public override var representedObject: Any? {
		didSet {
			updateUI()
		}
	}

	public override var isSelected: Bool {
		didSet {
			cardView?.borderTopColor = isSelected ? CardCollectionViewItem.selectedBorderColor : CardCollectionViewItem.normalBorderColor
		}
	}

	private func updateUI() {
		guard
			let estimation = representedObject as? PossibleEstimation,
			let cardView = cardView
			else { return }

		cardView.text = estimation.display
	}
}
