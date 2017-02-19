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
import SwiftyJSON

enum DetectionType: String {
    case crosswalk
    case face
}


class CrosswalkViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    
    
    // MARK - Const
    /************************************************************/
    
    struct Text {
        static let processing = "Processing image..."
    }

    
    struct Tag {
        static let crosswalk = "crosswalk"
    }
    
    struct Sug {
        static let nowalk = "Do not cross the street!"
        static let yeswalk = "It's safe to cross the street!"
        static let wherewalk = "There are no pedestrain lights near by, please take extra care!"
        
    }
    
    // MARK - Outlets
    /************************************************************/
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imagePreview: UIView!
    @IBOutlet weak var capturedImage: UIImageView! { didSet { capturedImage.isHidden = true } }

    
    // MARK - var
    /************************************************************/
    
    var tag: DetectionType = .crosswalk
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
        
        print(tag.rawValue)
        
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
    
    func textToSpeech(answer:String) {
        print("textToSpeech")
        let utterance = AVSpeechUtterance(string: answer)
        utterance.rate = 0.55
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        print("textToSpeech finished")
        
    }

    
    func uploadImage(image: UIImage?) {
        
        //compress
        guard let image = image else { print("image not found"); return; }
        let jpegCompressionQuality: CGFloat = 0.9 // Set this to whatever suits your purpose
        guard let base64String = UIImageJPEGRepresentation(image, jpegCompressionQuality)?.base64EncodedString() else { print("jpg->base64 failure"); return; }
        
        
        //send to server
        let imgData: [String: Any] = [
//            "img": base64String,
//            "tag": tag.rawValue
            "name": 3
        ]
        
//        print("TAG: \(tag.rawValue)")
//        Alamofire.request(URL.uploadImage, method: .post, parameters: imgData).responseJSON { response in
//        Alamofire.request(URL.uploadImage, method: .post, parameters: imgData).responseJSON { response in
//     
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)
//            
//            if let json = response.result.value {
//               print(json)
//            }
//        }
        
//            Alamofire.request(URL.uploadImage, method: .get).responseJSON { response in
//    
//                print(response.request)  // original URL request
//                print(response.response) // HTTP URL response
//                print(response.data)     // server data
//                print(response.result)
//    
//                if let json = response.result.value {
//                   print(json)
//                }
//            }
        
//            let params:NSMutableDictionary? = ["foo": "bar"];
//            let ulr =  NSURL(string:URL.uploadImage)
//            let request = NSMutableURLRequest(url: ulr)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
//            
//            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//            if let json = json {
//                print(json)
//            }
//            request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
//            
//            
//            Alamofire.request(request as! URLRequestConvertible)
//                .responseJSON { response in
//                    // do whatever you want here
//                    print(response.request)
//                    print(response.response)
//                    print(response.data)
//                    print(response.result)
//                    
//            }
        
        let urlstring: String = "http:/172.20.10.4:8001/process-image"
        let myurl = URL(string: urlstring)
        var request = URLRequest(url:  myurl!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let values = [
            "img": base64String,
            "tag": tag.rawValue
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: values)
        
        Alamofire.request(request)
            .responseJSON { [weak self]  response in
                // do whatever you want here
                
                guard let strongSelf = self else { return }
                
                if let json = response.result.value {
                    let jsonRes = JSON(json)
                    let res = jsonRes["result"].int

                    guard res != nil else { return }
                    switch res! {
                    case 1: strongSelf.textLabel.text = "Safe to walk!"
                        strongSelf.textToSpeech(answer: Sug.yeswalk)
                    case 0: strongSelf.textLabel.text = "Don't walk!"
                        strongSelf.textToSpeech(answer: Sug.nowalk)
                    case -1: strongSelf.textLabel.text = "Unable to find crosswalk!"
                        strongSelf.textToSpeech(answer: Sug.wherewalk)
                    default: break
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
//            if let wnd = self.view {
//
//                let v = UIView(frame: wnd.bounds)
//                v.backgroundColor = UIColor.white
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
            
            uploadImage(image: capturedImage.image)
        }
    }
}
