//
//  ViewController.swift
//  Street Smartz
//
//  Created by Gavi Rawson on 2/18/17.
//  Copyright © 2017 Graws Inc. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var speechButton: UIButton!
    
    @IBAction func speechPermissionPressed(_ sender: UIButton) {
        speechPermissionRequest()
    }
    
    @IBAction func speechRequestPressed(_ sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechButton.isEnabled = false
            speechButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            speechButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechButton.isEnabled = false
        speechRecognizer?.delegate = self
    }
    
    
    func speechPermissionRequest() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation { [weak self] in
                guard let strongSelf = self else { return }
                switch authStatus {
                case .authorized:
                    strongSelf.speechButton.isEnabled = true
                case .denied:
                    strongSelf.speechButton.isEnabled = false
                    strongSelf.speechButton.setTitle("User denied access to speech recognition", for: .disabled)
                case .restricted:
                    strongSelf.speechButton.isEnabled = false
                    strongSelf.speechButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                case .notDetermined:
                    strongSelf.speechButton.isEnabled = false
                    strongSelf.speechButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    func startRecording() {
        
        // clear previous recognition task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        //set up audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                print(result?.bestTranscription.formattedString)
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.speechButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        print("Say something, I'm listening!")
    }
    
    
    @IBAction func textToSpeechButton(_ sender: Any) {
        textToSpeech(answer:"Yes, it is safe to cross the street!");
    }
    
    func textToSpeech(answer:String) {
        print("button pressed")
        let utterance = AVSpeechUtterance(string: answer)
        utterance.rate = 0.55
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }


}

extension ViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            speechButton.isEnabled = true
        } else {
            speechButton.isEnabled = false
        }
    }
}

