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

private func foo(color: NSColor) -> NSColor {
	return color.blended(withFraction: 0.5, of: NSColor.black) ?? color
}

@IBDesignable
internal final class BasicCardView: NSView {
	@IBInspectable public var borderTopColor: NSColor?
	@IBInspectable public var borderBottomColor: NSColor?

	@IBInspectable public var backgroundTopColor: NSColor?
	@IBInspectable public var backgroundBottomColor: NSColor?

	@IBInspectable public var cornerRadius: CGFloat = 5.0

	override func draw(_ dirtyRect: NSRect) {
		guard let context = NSGraphicsContext.current?.cgContext else { return }
		context.saveGState()

		let borderTopColor = self.borderTopColor ?? NSColor.white
		let backgroundTopColor = self.backgroundTopColor ?? NSColor.systemOrange

		let bottomBorderColor = borderBottomColor ?? foo(color: borderTopColor)
		let bottomBackgroundColor = backgroundBottomColor ?? foo(color: backgroundTopColor)

		drawRoundedRect(in: context, rect: frame, withCornerRadius: cornerRadius, gradientStartColor: borderTopColor.cgColor, gradientEndColor: bottomBorderColor.cgColor)
		drawRoundedRect(in: context, rect: NSInsetRect(frame, cornerRadius, cornerRadius), withCornerRadius: cornerRadius, gradientStartColor: backgroundTopColor.cgColor, gradientEndColor: bottomBackgroundColor.cgColor)

		context.restoreGState()
	}
}
