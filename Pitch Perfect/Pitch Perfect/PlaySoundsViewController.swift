//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Christine Lang on 3/18/15.
//  Copyright (c) 2015 Christine Lang. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer {
        //1
        var path = NSBundle.mainBundle().pathForResource(file, ofType:type)
        var url = NSURL.fileURLWithPath(path!)
        //2
        var error: NSError?
        
        //3
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        audioPlayer?.enableRate = true
        
        //4
        return audioPlayer!
        
    }
    
    func playAudio(rate:Float32) {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopAudioSub(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        stopAudioSub()
        playAudio(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        stopAudioSub()
        playAudio(2)
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAudioSub()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
        
    }
    
    @IBAction func stopAudioPlay(sender: UIButton) {
        stopAudioSub()

    }
    
    
}
