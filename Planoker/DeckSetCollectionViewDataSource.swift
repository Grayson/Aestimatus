//
//  DeckSetCollectionViewDataSource.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/26/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import AppKit

internal final class DeckSetCollectionViewDataSource: NSObject, NSCollectionViewDataSource {
	public var deckSet: DeckSet?

	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return deckSet?.possibleEstimations.count ?? 0
	}

	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CardCollectionViewItem"), for: indexPath)
		guard let cardItem = item as? CardCollectionViewItem else { return item }
		cardItem.representedObject = deckSet?.possibleEstimations[indexPath.item]
		return cardItem
	}
}
