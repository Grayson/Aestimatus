//
//  DisplayWindowViewController.swift
//  Planoker
//
//  Created by Grayson Hansard on 7/27/18.
//  Copyright © 2018 From Concentrate Software. All rights reserved.
//

import Cocoa
import AVFoundation

internal final class DisplayWindowViewController: NSViewController {
	@IBOutlet public var videoHostView: NSView?
	@IBOutlet weak var stageBackgroundView: NSView?

	private let captureSession = AVCaptureSession()
	private var captureDevice: AVCaptureDevice?
	private let cardLayer = CALayer()

	public var isCapturingVideo: Bool {
		get { return captureSession.isRunning }
	}

	public func startCapture() {
		captureSession.startRunning()
	}

	public func stopCapture() {
		captureSession.stopRunning()
	}

	public func placeOnStage(_ estimation: PossibleEstimation) {
		guard let stageBackgroundLayer = stageBackgroundView?.layer else { return }
		let cardBounds = cardLayer.bounds
		let newX = floor((stageBackgroundLayer.bounds.width - cardBounds.width) / 2.0)
		let newY = -1.0 * cardBounds.size.height + 20.0
		cardLayer.frame = CGRect(origin: CGPoint(x: newX, y: newY), size: cardBounds.size)
	}

	public func removeFromStage() {
		guard let stageBackgroundLayer = stageBackgroundView?.layer else { return }
		let cardBounds = cardLayer.bounds
		let newX = floor((stageBackgroundLayer.bounds.width - cardBounds.width) / 2.0)
		let newY = -1.0 * cardBounds.size.height
		cardLayer.frame = CGRect(origin: CGPoint(x: newX, y: newY), size: cardBounds.size)
	}

	public func showEstimation(_ estimation: PossibleEstimation) {
		guard let stageBackgroundLayer = stageBackgroundView?.layer else { return }

		let displayAttributes = [
			NSAttributedString.Key.font: NSFont.systemFont(ofSize: 32.0),
			NSAttributedString.Key.foregroundColor: NSColor.white,
		]
		let display = NSAttributedString(string: estimation.display, attributes: displayAttributes)
		resetCardLayer(display: display)

		let cardBounds = cardLayer.bounds
		let newX = floor((stageBackgroundLayer.bounds.width - cardBounds.width) / 2.0)
		let newY = floor((stageBackgroundLayer.bounds.height - cardBounds.height) / 2.0)
		cardLayer.frame = CGRect(origin: CGPoint(x: newX, y: newY), size: cardBounds.size)
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupCardLayer()

		captureSession.sessionPreset = .low
		guard
			let hostView = videoHostView,
			let device = (AVCaptureDevice.devices().first { $0.hasMediaType(AVMediaType.video) })
			else { return }

			let layer = CALayer()
			layer.shadowColor = NSColor.black.cgColor
			layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
			layer.shadowRadius = 2.0
			layer.shadowOpacity = 0.5
			hostView.layer = layer

			DispatchQueue.main.async {
				do {
					try self.captureSession.addInput(AVCaptureDeviceInput(device: device))
					let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
					previewLayer.frame = layer.bounds
					layer.addSublayer(previewLayer)
					self.startCapture()
				}
				catch {
					self.presentError(error)
				}
		}
	}

	private func resetCardLayer(display: NSAttributedString?) {
		let cardSize = NSSize(width: 200, height: 280)
		let image = NSImage(size: cardSize)
		image.lockFocus()

		guard let context = NSGraphicsContext.current?.cgContext else { return }

		let cardBounds = CGRect(origin: CGPoint.zero, size: cardSize)
		let cardColors = BasicCardColors(backgroundStartColor: NSColor.orange.cgColor, backgroundEndColor: NSColor.orange.cgColor, borderStartColor: NSColor.white.cgColor, borderEndColor: NSColor.white.cgColor)
		if let display = display {
			drawCard(in: context, bounds: cardBounds, cornerRadius: 3.0, colors: cardColors, display: display)
		}
		else {
			drawCard(in: context, bounds: cardBounds, cornerRadius: 3.0, colors: cardColors)
		}
		image.unlockFocus()
		cardLayer.frame = CGRect(origin: CGPoint(x: 0.0, y: -cardSize.height), size: cardSize)
		cardLayer.contents = image
	}

	private func setupCardLayer() {
		resetCardLayer(display: nil)
		let stageLayer = CALayer()
		stageLayer.backgroundColor = NSColor.darkGray.cgColor
		stageBackgroundView?.layer = stageLayer
		stageLayer.addSublayer(cardLayer)
		cardLayer.shadowColor = NSColor.black.cgColor
		cardLayer.shadowOffset = CGSize(width: 0.0, height: -10.0)
		cardLayer.shadowRadius = 5.0
		cardLayer.shadowOpacity = 0.5
	}
}
