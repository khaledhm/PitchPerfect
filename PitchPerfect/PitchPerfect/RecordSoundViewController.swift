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
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButten: UIButton!
    @IBOutlet weak var stopRecordingButten: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButten.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- Audio recording
    @IBAction func recordAudio(_ sender: Any) {
        toggleButtens(true)
        
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
    
    
    //MARK:- Stop recording
    @IBAction func stopRecording(_ sender: Any) {
        toggleButtens(false)
        
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
        if segue.identifier == "stopRecording"{
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recirdedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recirdedAudioURL
        }
    }
    
    
    func toggleButtens(_ isRecording: Bool){
        
        recordButten.isEnabled = !isRecording
        stopRecordingButten.isEnabled = isRecording
        
        if isRecording{
            recordingLabel.text = "Recording in progress"
        }else{
            recordingLabel.text = "Tab To Record"
        }
    }
    
    
}

