//
//  EffectSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Pedro Romao on 16/12/2017.
//  Copyright © 2017 romaopedro. All rights reserved.
//

import UIKit
import AVFoundation

class EffectSoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var buttonSlow: UIButton!
    @IBOutlet weak var buttonFast: UIButton!
    @IBOutlet weak var buttonHighPitch: UIButton!
    @IBOutlet weak var buttonLowPitch: UIButton!
    @IBOutlet weak var buttonEcho: UIButton!
    @IBOutlet weak var buttonReverb: UIButton!
    
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayer: AVAudioPlayer!
    
    var audioRecorder : AVAudioRecorder!
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let AudioPlayerError = "Audio Player Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf:audioRecorder.url )
        } catch {
            showAlert(Alerts.AudioPlayerError, message: String(describing: error))
        }
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        
        do {
            try audioFile = AVAudioFile(forReading: audioRecorder.url)
        } catch {
            showAlert(Alerts.AudioFileError, message: String(describing: error))
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func playWithRate(_ rate: Float) {
        stopPlaying()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playWithEffect(_ effect: AVAudioUnit) {
        stopPlaying()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
        } catch {
            showAlert(Alerts.AudioEngineError, message: String(describing: error))
        }
        
        audioPlayerNode.play()
    }
    
    func stopPlaying() {
        audioEngine.stop()
        audioPlayer.stop()
        audioEngine.reset()
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //snail
    @IBAction func buttonSlowPressed(_ sender: Any) {
        playWithRate(0.5)
    }
    
    //rabbit
    @IBAction func buttonFastPressed(_ sender: Any) {
        playWithRate(1.5)
    }
    
    //squirl
    @IBAction func buttonHighPitchPressed(_ sender: Any) {
        let effect = AVAudioUnitTimePitch()
        effect.pitch = 1000
        
        playWithEffect(effect)
    }
    
    //darth vader
    @IBAction func buttonLowPitchPressed(_ sender: Any) {
        let effect = AVAudioUnitTimePitch()
        effect.pitch = -1000
        
        playWithEffect(effect)
    }
    
    //bird
    @IBAction func buttonEchoPressed(_ sender: Any) {
        let effect = AVAudioUnitDelay()
        effect.delayTime = 0.5
        effect.feedback = 30
        
        playWithEffect(effect)
    }
    
    //red
    @IBAction func buttonReverbPressed(_ sender: Any) {
        let effect = AVAudioUnitReverb()
        
        playWithEffect(effect)
    }

    @IBAction func buttonRecordNewSoundPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
