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
	private let captureSession = AVCaptureSession()
	private var captureDevice: AVCaptureDevice?

	public func startCapture() {
		captureSession.startRunning()
	}

	public func stopCapture() {
		captureSession.stopRunning()
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		captureSession.sessionPreset = .low
		guard
			let hostView = videoHostView,
			let device = (AVCaptureDevice.devices().first { $0.hasMediaType(AVMediaType.video) })
			else { return }

			let layer = CALayer()
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
}
