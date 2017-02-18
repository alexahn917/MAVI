//
//  CrosswalkViewController.swift
//  Street Smartz
//
//  Created by Gavi Rawson on 2/18/17.
//  Copyright © 2017 Graws Inc. All rights reserved.
//

import UIKit
import AVFoundation

class CrosswalkViewController: UIViewController {
    
    
    // MARK - Const
    /************************************************************/
    
    struct Text {
        static let processing = "Processing image..."
    }
    
    // MARK - Outlets
    /************************************************************/
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imagePreview: UIView!
    @IBOutlet weak var capturedImage: UIImageView! { didSet { capturedImage.isHidden = true } }

    
    // MARK - var
    /************************************************************/
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    
    // MARK - Actions
    /************************************************************/

    
    @IBAction func captureImage() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewPixelType, kCVPixelBufferWidthKey as String : 160, kCVPixelBufferHeightKey as String : 160]
        
        settings.previewPhotoFormat = previewFormat
        sessionOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK - Life cycle
    /************************************************************/
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayImagePreview()
        
        Timer.scheduledTimer(
            timeInterval: 3.0, target: self,
            selector: #selector(captureImage),
            userInfo: nil, repeats: false)

    }
    
    func displayImagePreview() {
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
                            imagePreview.layer.addSublayer(previewLayer)
                            //cameraView.addSubview(captureButton)
                            
                            previewLayer.position = CGPoint(x: imagePreview.frame.width/2, y: imagePreview.frame.height/2)
                            previewLayer.bounds = imagePreview.frame
                            
                            captureSession.startRunning()
                        }
                    }
                    
                } catch let avError {
                    print(avError)
                }
            }
        }

    }

}

extension CrosswalkViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        guard error == nil else {  print(error!.localizedDescription); return; }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            //animate flash 
//            if let wnd = self.view{
//                
//                var v = UIView(frame: wnd.bounds)
//                v.backgroundColor = UIColor.red()
//                v.alpha = 1
//                
//                wnd.addSubview(v)
//                UIView.animate(withDuration: 1, animations: { 
//                    v.alpha = 0
//                }, completion: {(finished:Bool) in
//                    v.removeFromSuperview()
//                })
//            }
            
            capturedImage.isHidden = false
            capturedImage.image = UIImage(data: dataImage)
            captureSession.stopRunning()
            previewLayer.removeFromSuperlayer()
            
            textLabel.text = Text.processing
        }
    }
}
