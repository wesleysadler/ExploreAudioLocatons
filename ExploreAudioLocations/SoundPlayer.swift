//
//  SoundPlayer.swift
//  ExploreAudioLocations
//
//  Created by Wesley Sadler on 7/19/15.
//  Copyright (c) 2015 Digital Sadler. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer {
    
    var audioPlayer = AVAudioPlayer()
    
    init?(birdSoundLocation:BirdSoundLocation) {
        
        // get path to sound file
        let soundFilePath = NSBundle.mainBundle().pathForResource(birdSoundLocation.soundFile, ofType: "wav")
        
        if let soundFile = soundFilePath {
            // transform sound file path to url
            let fileUrl = NSURL(fileURLWithPath: soundFile)
            
            var error:NSError?
            audioPlayer = AVAudioPlayer(contentsOfURL: fileUrl, error: &error)
            
            if let playerError = error {
                println("Error - Sound Player Setup \(fileUrl)")
                return nil
            }
            
            audioPlayer.enableRate = true
            audioPlayer.prepareToPlay()
            
        } else {
            println("Error - Sound File Not Found")
            return nil
        }
    }
    
    func playAudio() {
        self.audioPlayer.play()
    }
    
    func pauseAudio() {
        self.audioPlayer.pause()
    }
    
    func stopAudio() {
        self.audioPlayer.stop()
    }
    
    func isPlaying() -> Bool {
        return self.audioPlayer.playing
    }
    
    // volume is relative to hardware volume
    func setVolume(volume: Float) {
        self.audioPlayer.volume = volume
    }
    
    func getVolume() -> Float {
        return self.audioPlayer.volume
    }
    
    func setCurrentAudioTime(currentTime: NSTimeInterval) {
        self.audioPlayer.currentTime = currentTime
    }
    
    func getCurrentAudioTime() -> NSTimeInterval {
        return self.audioPlayer.currentTime
    }
    
    func getAudioDuration() -> NSTimeInterval {
        return self.audioPlayer.duration
    }
    
    func setAudioRate(rate: Float) {
        self.audioPlayer.rate = rate
    }
    
}