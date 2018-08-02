import Cocoa
import PlaygroundSupport

func drawRoundedRect(in context: CGContext, rect: CGRect, withCornerRadius cornerRadius: CGFloat, gradientStartColor: CGColor, gradientEndColor: CGColor) {
	let path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
	context.addPath(path)
	context.clip()
	let gradient = CGGradient(colorsSpace: context.colorSpace, colors: [gradientStartColor, gradientEndColor] as CFArray, locations: nil)!
	let gradientStart = CGPoint(x: 0.0, y: NSHeight(rect))
	let gradientEnd = CGPoint(x: NSWidth(rect), y: 0.0)
	context.drawLinearGradient(gradient, start: gradientStart, end: gradientEnd, options: [])
}

// Invariants
let frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0)
let borderStartColor = NSColor.white
let borderEndColor = NSColor.white.blended(withFraction: 0.5, of: NSColor.black)!
let cornerRadius: CGFloat = 5.0

let cardBackgroundStartColor = NSColor.red
let cardBackgroundEndColor = NSColor.red.blended(withFraction: 0.5, of: NSColor.black)!

// Calculations
let cardHeightToWidthRatio: CGFloat = 1.4
let cardWidthToHeightRatio: CGFloat = 1.0 / cardHeightToWidthRatio
let heightBasedOnWidth = frame.width * cardHeightToWidthRatio
let finalHeight = floor(heightBasedOnWidth <= frame.height ? heightBasedOnWidth : frame.height)
let finalWidth = floor(finalHeight == frame.height ? frame.height * cardWidthToHeightRatio : frame.width)
let cardFrame = CGRect(x: 0.0, y: 0.0, width: finalWidth, height: finalHeight)

let image = NSImage(size: cardFrame.size)
image.lockFocus()
let context = NSGraphicsContext.current!.cgContext

// Drawing
context.saveGState()

drawRoundedRect(in: context, rect: cardFrame, withCornerRadius: cornerRadius, gradientStartColor: borderStartColor.cgColor, gradientEndColor: borderEndColor.cgColor)
drawRoundedRect(in: context, rect: NSInsetRect(cardFrame, 5.0, 5.0), withCornerRadius: cornerRadius, gradientStartColor: cardBackgroundStartColor.cgColor, gradientEndColor: cardBackgroundEndColor.cgColor)

context.restoreGState()
image.unlockFocus()
