//
//  DeckSetCollectionViewDelegate.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/26/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import AppKit

final class DeckSetCollectionViewDelegate: NSObject, NSCollectionViewDelegate {
	public var selectionChanged: (NSCollectionView) -> () = { _ in }

	func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
		selectionChanged(collectionView)
	}

	func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
		selectionChanged(collectionView)
	}
}
