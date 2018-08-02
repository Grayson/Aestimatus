//
//  BasicCardRenderer.swift
//  Aestimatus
//
//  Created by Grayson Hansard on 8/1/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import AppKit
import Foundation
import QuartzCore

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

private func doDrawCard(in context: CGContext, bounds: CGRect, cornerRadius: Float, colors: BasicCardColors) {
	drawRoundedRect(in: context, rect: bounds, withCornerRadius: CGFloat(cornerRadius), gradientStartColor: colors.borderStartColor, gradientEndColor: colors.borderEndColor)
	drawRoundedRect(in: context, rect: NSInsetRect(bounds, CGFloat(cornerRadius), CGFloat(cornerRadius)), withCornerRadius: CGFloat(cornerRadius), gradientStartColor: colors.backgroundStartColor, gradientEndColor: colors.backgroundEndColor)
}

public struct BasicCardColors {
	public let backgroundStartColor: CGColor
	public let backgroundEndColor: CGColor
	public let borderStartColor: CGColor
	public let borderEndColor: CGColor
}

public func drawCard(in context: CGContext, bounds: CGRect, cornerRadius: Float, colors: BasicCardColors) {
	context.saveGState()
	doDrawCard(in: context, bounds: bounds, cornerRadius: cornerRadius, colors: colors)
	context.restoreGState()
}

public func drawCard(in context: CGContext, bounds: CGRect, cornerRadius: Float, colors: BasicCardColors, display: NSAttributedString) {
	context.saveGState()
	doDrawCard(in: context, bounds: bounds, cornerRadius: cornerRadius, colors: colors)
	display.draw(in: calculateFrame(for: display, in: bounds))
	context.restoreGState()
}
