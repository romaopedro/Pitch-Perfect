//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Pedro Romao on 13/12/2017.
//  Copyright © 2017 romaopedro. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonStartRecording: UIButton!
    @IBOutlet weak var buttonStopRecoding: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        navigationController?.navigationBar.isHidden = true
        buttonStartRecording.isEnabled = true
        buttonStopRecoding.isEnabled = false
        labelDescription.text = "Tap to start Recording"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func startRecording(_ sender: Any) {
        
        labelDescription.text = "Recording..."
        buttonStopRecoding.isEnabled = true
        buttonStartRecording.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        audioRecorder.stop()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueEffects" {
            let effectVC = segue.destination as! EffectSoundsViewController
            
            effectVC.audioRecorder = sender as! AVAudioRecorder
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        performSegue(withIdentifier: "segueEffects", sender: recorder)
        
    }
    
}

