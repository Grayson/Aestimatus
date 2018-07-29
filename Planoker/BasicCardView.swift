//
//  BasicCardView.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/29/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import AppKit

func drawRoundedRect(in context: CGContext, rect: CGRect, withCornerRadius cornerRadius: CGFloat, gradientStartColor: CGColor, gradientEndColor: CGColor) {
	let path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
	context.addPath(path)
	context.clip()
	let gradient = CGGradient(colorsSpace: context.colorSpace, colors: [gradientStartColor, gradientEndColor] as CFArray, locations: nil)!
	let gradientStart = CGPoint(x: 0.0, y: NSHeight(rect))
	let gradientEnd = CGPoint(x: NSWidth(rect), y: 0.0)
	context.drawLinearGradient(gradient, start: gradientStart, end: gradientEnd, options: [])
}

private func darkenColor(color: NSColor) -> NSColor {
	return color.blended(withFraction: 0.5, of: NSColor.black) ?? color
}

@IBDesignable
internal final class BasicCardView: NSView, CALayerDelegate {
	@IBInspectable public var borderTopColor: NSColor?
	@IBInspectable public var borderBottomColor: NSColor?

	@IBInspectable public var backgroundTopColor: NSColor?
	@IBInspectable public var backgroundBottomColor: NSColor?

	@IBInspectable public var cornerRadius: CGFloat = 5.0

	private let cardLayer = CALayer()

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		setupLayer()
	}

	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
		setupLayer()
	}

	func draw(_ layer: CALayer, in context: CGContext) {
		switch layer {
		case cardLayer:
			let borderTopColor = self.borderTopColor ?? NSColor.white
			let backgroundTopColor = self.backgroundTopColor ?? NSColor.systemOrange

			let bottomBorderColor = borderBottomColor ?? darkenColor(color: borderTopColor)
			let bottomBackgroundColor = backgroundBottomColor ?? darkenColor(color: backgroundTopColor)

			drawRoundedRect(in: context, rect: cardLayer.bounds, withCornerRadius: cornerRadius, gradientStartColor: borderTopColor.cgColor, gradientEndColor: bottomBorderColor.cgColor)
			drawRoundedRect(in: context, rect: NSInsetRect(cardLayer.bounds, cornerRadius, cornerRadius), withCornerRadius: cornerRadius, gradientStartColor: backgroundTopColor.cgColor, gradientEndColor: bottomBackgroundColor.cgColor)
		default:
			break
		}
	}

	func layoutSublayers(of layer: CALayer) {
		guard layer == self.layer else { return }
		let frame = layer.frame

		let cardHeightToWidthRatio: CGFloat = 1.4
		let cardWidthToHeightRatio: CGFloat = 1.0 / cardHeightToWidthRatio
		let heightBasedOnWidth = frame.width * cardHeightToWidthRatio
		let finalHeight = floor(heightBasedOnWidth <= frame.height ? heightBasedOnWidth : frame.height)
		let finalWidth = floor(finalHeight == frame.height ? frame.height * cardWidthToHeightRatio : frame.width)

		let x: CGFloat = floor((layer.frame.width - finalWidth) / 2.0)
		let cardFrame = CGRect(x: x, y: 0.0, width: finalWidth, height: finalHeight)

		cardLayer.frame = cardFrame
	}

	private func setupLayer() {
		let layer: CALayer = {
			if nil == self.layer {
				self.layer = CALayer()
				self.layer!.delegate = self
			}
			return self.layer!
		}()
		layer.addSublayer(cardLayer)
		cardLayer.delegate = self
		cardLayer.setNeedsDisplay()
	}
}
