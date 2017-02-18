//
//  CameraViewController.swift
//  Street Smartz
//
//  Created by Gavi Rawson on 2/18/17.
//  Copyright © 2017 Graws Inc. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()

    // MARK - Outlets
    /******************************************************/
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    
    @IBAction func capturePressed(_ sender: UIButton) {
        print("capture pressed")
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewPixelType, kCVPixelBufferWidthKey as String : 160, kCVPixelBufferHeightKey as String : 160]
        
        settings.previewPhotoFormat = previewFormat
        sessionOutput.capturePhoto(with: settings, delegate: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let deviceSession = AVCaptureDeviceDiscoverySession(
            deviceTypes: [.builtInDuoCamera, .builtInTelephotoCamera, .builtInWideAngleCamera],
            mediaType: AVMediaTypeVideo, position: .unspecified)
        
        for device in (deviceSession?.devices)! {
            if device.position == AVCaptureDevicePosition.back {
                do {
                    
                    let input = try AVCaptureDeviceInput(device: device)
                    if captureSession.canAddInput(input) {
                        captureSession.addInput(input)
                        if captureSession.canAddOutput(sessionOutput) {
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = .portrait
                            cameraView.layer.addSublayer(previewLayer)
//                            cameraView.addSubview(captureButton)
                            
                            previewLayer.position = CGPoint(x: cameraView.frame.width/2, y: cameraView.frame.height/2)
                            previewLayer.bounds = cameraView.frame
                            
                            captureSession.startRunning()
                        }
                    }
                    
                } catch let avError {
                    print(avError)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        guard error == nil else {  print(error!.localizedDescription); return; }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            capturedImage.image = UIImage(data: dataImage)
            captureSession.stopRunning()
            previewLayer.removeFromSuperlayer()
        }
    }
}
