//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Khaled H on 22/11/2018.
//  Copyright © 2018 Khaled H. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    //var recording: Bool = true
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButten: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        recordButten.contentMode = .scaleAspectFit
        recordButten.imageView?.contentMode = .scaleAspectFit
    }

    
    //MARK:- Audio recording
    @IBAction func recordAudio(_ sender: Any) {
        toggleButtons(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //MARK:- Stop Recording
    @IBAction func stopRecording() {
        toggleButtons(false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    
    //MARK:- segue and view transitions
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording was not successful")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "stopRecording" else { return }
        guard let playSoundVC = segue.destination as? PlaySoundViewController else { return }
        guard let recordedAudioURL = sender as? URL else { return }
        playSoundVC.recordedAudioURL = recordedAudioURL
    }
    
    
    
    
    func toggleButtons(_ isRecording: Bool){
        
        recordButten.isEnabled = !isRecording
        stopButton.isEnabled = isRecording
        
        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
    }
    
    
    
    
    
    
    
}

