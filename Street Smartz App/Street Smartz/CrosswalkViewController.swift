//
//  CrosswalkViewController.swift
//  Street Smartz
//
//  Created by Gavi Rawson on 2/18/17.
//  Copyright © 2017 Graws Inc. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class CrosswalkViewController: UIViewController {
    
    
    // MARK - Const
    /************************************************************/
    
    struct Text {
        static let processing = "Processing image..."
    }
    
    struct URL {
        static let uploadImage = "http://127.0.0.1:8000/image/"
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
    
    func uploadImage(image: UIImage?) {
        
//        let str = "Hello, playground"
//        guard let base64Str = str.base64Encoded() else { return }

        guard let image = image else { return }
        guard let imageData = UIImagePNGRepresentation(image) else { return }
//        Alamofire.upload(imageData, to: "http://httpbin.org/post").responseJSON { response in
//            debugPrint(response)
//        }
        Alamofire.request("127.0.0.1:8002/image/").responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
       
    }
}

extension CrosswalkViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        guard error == nil else {  print(error!.localizedDescription); return; }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            //animate flash 
            if let wnd = self.view {

                let v = UIView(frame: wnd.bounds)
                v.backgroundColor = UIColor.white
                v.alpha = 1
                
                wnd.addSubview(v)
                UIView.animate(withDuration: 1, animations: { 
                    v.alpha = 0
                }, completion: {(finished:Bool) in
                    v.removeFromSuperview()
                })
            }
            
            capturedImage.isHidden = false
            capturedImage.image = UIImage(data: dataImage)
            captureSession.stopRunning()
            previewLayer.removeFromSuperlayer()
            textLabel.text = Text.processing
            
            uploadImage(image: capturedImage.image)
        }
    }
}
