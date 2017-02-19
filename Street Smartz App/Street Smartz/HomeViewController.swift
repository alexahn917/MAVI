//
//  HomeViewController.swift
//  Street Smartz
//
//  Created by Gavi Rawson on 2/18/17.
//  Copyright © 2017 Graws Inc. All rights reserved.
//

import UIKit
import Speech

class HomeViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    // MARK - Const
    /************************************************************/
    
    struct Text {
        static let deflt = "Hey there"
        static let listening = "What's up?"
        static let voiceListening = "I am listening"
        static let voicedeflt = "Hey there, Mavi here, what can I help you with?"
        
    }
    
    struct Storyboard {
        static let showCrosswalk = "show_crosswalk"
        
    }
    
    
    // MARK - Outlets
    /************************************************************/
    
    @IBOutlet weak var mic: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textLabel: UILabel!

    
    // MARK - Actions
    /************************************************************/

    @IBAction func textToSpeechButton(_ sender: Any) {
        textToSpeech(answer:"Yes, it is safe to cross the street!");
    }
    
    // MARK - Var
    /************************************************************/
    
    fileprivate var tag: DetectionType?
    fileprivate var speechEnabled = false
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    fileprivate var wantToRecord = false;

    
    // MARK - Life cycle
    /************************************************************/

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        speechPermissionRequest()
        speechRecognizer?.delegate = self
        
        //gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
        
        textToSpeech(answer: Text.voicedeflt)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textLabel.text = Text.listening
    }
    
    
    
    
    // MARK - func
    /************************************************************/

    func tapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechEnabled = false
            
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            mic.isHidden = false
            print("Stopped recording")
            
            if textLabel.text == Text.listening {
                textLabel.text = Text.deflt
            }
        } else {
            print("about to record")
            wantToRecord = true
            textToSpeech(answer: Text.voiceListening)
        }
    }
    
    func speechPermissionRequest() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation { [weak self] in
                guard let strongSelf = self else { return }
                switch authStatus {
                case .authorized:
                    strongSelf.speechEnabled = true
                default:
                    strongSelf.speechEnabled = false
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
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print(wantToRecord)
        if (wantToRecord) {
            wantToRecord = false
            startRecording()
            mic.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            print("Started Recording")
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
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in
            guard let strongSelf = self else { return }

            var isFinal = false
            
            if result != nil {
                DispatchQueue.main.async {
                    strongSelf.textLabel.text = result?.bestTranscription.formattedString
                    strongSelf.parseSpeech(str: result?.bestTranscription.formattedString)
                }
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                strongSelf.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                strongSelf.recognitionRequest = nil
                strongSelf.recognitionTask = nil
                strongSelf.speechEnabled = true
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
        
        textLabel.text = Text.listening
    }
    
    func parseSpeech(str: String?) {
        if (str?.range(of: "cross") != nil && str?.range(of: "street") != nil) {
            tag = .crosswalk
            performSegue(withIdentifier: Storyboard.showCrosswalk, sender: self)
        } else if str?.range(of: "people") != nil {
            tag = .face
            performSegue(withIdentifier: Storyboard.showCrosswalk, sender: self)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showCrosswalk {
            if let destinationVC = segue.destination as? CrosswalkViewController {
                destinationVC.tag = tag ?? .crosswalk
            }
        }
    }

}

extension HomeViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            speechEnabled = true
        } else {
            speechEnabled = false
        }
    }
}
