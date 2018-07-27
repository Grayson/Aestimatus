//
//  CardCollectionViewItem.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/26/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Cocoa

internal final class CardCollectionViewItem: NSCollectionViewItem {
	public override var representedObject: Any? {
		didSet {
			updateUI()
		}
	}

	public override var isSelected: Bool {
		didSet {
			textField?.textColor = isSelected ? NSColor.red : NSColor.textColor
		}
	}

	private func updateUI() {
		guard
			let estimation = representedObject as? PossibleEstimation
			else { return }

		textField?.stringValue = estimation.display
	}
}
