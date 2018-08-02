//
//  BasicCardView.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/29/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import AppKit

private func drawRoundedRect(in context: CGContext, rect: CGRect, withCornerRadius cornerRadius: CGFloat, gradientStartColor: CGColor, gradientEndColor: CGColor) {
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

private func calculateCardFrame(in frame: CGRect) -> CGRect {
	let cardHeightToWidthRatio: CGFloat = 1.4
	let cardWidthToHeightRatio: CGFloat = 1.0 / cardHeightToWidthRatio
	let heightBasedOnWidth = frame.width * cardHeightToWidthRatio
	let finalHeight = floor(heightBasedOnWidth <= frame.height ? heightBasedOnWidth : frame.height)
	let finalWidth = floor(finalHeight == frame.height ? frame.height * cardWidthToHeightRatio : frame.width)

	let x: CGFloat = floor((frame.width - finalWidth) / 2.0)
	return CGRect(x: x, y: 0.0, width: finalWidth, height: finalHeight)
}

private func calculateFrame(for attributedString: NSAttributedString, in rect: CGRect) -> CGRect {
	let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
	var fitRange = CFRange()
	let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(), nil, rect.size, &fitRange)

	let x = (rect.size.width - suggestedSize.width) / 2.0 + rect.origin.x
	let y = (rect.size.height - suggestedSize.height) / 2.0 + rect.origin.y

	return CGRect(x: x, y: y, width: suggestedSize.width, height: suggestedSize.height)
}

private func attributedString(from layer: CATextLayer) -> NSAttributedString {
	if let attrStr = layer.string as? NSAttributedString {
		return attrStr
	}

	guard
		let font = layer.font as? NSFont,
		let string = layer.string as? String
		else { assert(false) }

	let attributes = [ NSAttributedString.Key.font: font ]
	return NSAttributedString(string: string, attributes: attributes)
}

@IBDesignable
internal final class BasicCardView: NSView, CALayerDelegate {
	@IBInspectable public var borderTopColor: NSColor? { didSet { cardLayer.setNeedsDisplay() }}
	@IBInspectable public var borderBottomColor: NSColor? { didSet { cardLayer.setNeedsDisplay() }}

	@IBInspectable public var backgroundTopColor: NSColor? { didSet { cardLayer.setNeedsDisplay() }}
	@IBInspectable public var backgroundBottomColor: NSColor? { didSet { cardLayer.setNeedsDisplay() }}

	@IBInspectable public var cornerRadius: CGFloat = 5.0 { didSet { cardLayer.setNeedsDisplay() }}

	@IBInspectable public var font: NSFont? {
		didSet {
			textLayer.font = font
		}
	}

	@IBInspectable public var textColor: NSColor? {
		didSet {
			textLayer.foregroundColor = textColor?.cgColor
		}
	}

	@IBInspectable public var text: String = "0" {
		didSet {
			textLayer.string = text
		}
	}

	private let cardLayer = CALayer()
	private let textLayer = CATextLayer()

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

		cardLayer.frame = calculateCardFrame(in: frame)
		textLayer.frame = calculateFrame(for: attributedString(from: textLayer), in: frame)
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

		layer.addSublayer(textLayer)
		textLayer.string = text
		textLayer.setNeedsDisplay()
	}
}
