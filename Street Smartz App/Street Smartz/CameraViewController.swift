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

    // MARK - Outlets
    /******************************************************/
    
    @IBOutlet weak var previewImage: UIView!
    
    
    // MARK - Actions
    /******************************************************/
   
    @IBAction func capturePressed(_ sender: UIButton) {
        
    }
    
    // MARK - Variables
    /******************************************************/
   
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
   
    
    // MARK - Life Cycle
    /******************************************************/
    


    
}
