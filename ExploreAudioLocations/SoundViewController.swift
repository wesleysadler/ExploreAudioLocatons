//
//  SoundViewController.swift
//  ExploreAudioLocations
//
//  Created by Wesley Sadler on 7/16/15.
//  Copyright (c) 2015 Digital Sadler. All rights reserved.
//
import Foundation
import UIKit

class SoundViewController: UIViewController
{
    
    // MARK: - Constants
    
    private struct Constants {
        static let InitialTimeString = "0:00"
        static let PlayButtonImageFileName = "play.png"
        static let PauseButtonImageFileName = "pause.png"
        static let SliderCircleThumbImage = "SliderCircleThumb.png"
        static let SliderColumnThumbImage = "SliderColumnThumb.png"
    }
    

    // MARK: - Outlets
    
    //    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var recordedDateLabel: UILabel!
    @IBOutlet weak var birdNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var timeElapsed: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!  {
        didSet {
            let thumbImage = UIImage(named: Constants.SliderColumnThumbImage)
            currentTimeSlider.setThumbImage(thumbImage, forState: UIControlState.Normal)
        }
    }
    
    @IBOutlet weak var soundRateSlider: UISlider! {
        didSet {
            let thumbImage = UIImage(named: Constants.SliderCircleThumbImage)
            soundRateSlider.setThumbImage(thumbImage, forState: UIControlState.Normal)
        }
    }
    
    var paused: Bool = true
    var dragging: Bool = false
    var timer: NSTimer?
    
    var birdSoundLocation: BirdSoundLocation?
    var audioPlayer: SoundPlayer?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupAudioPlayer()
        self.setupViewLabels()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.audioPlayer?.stopAudio()
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAudioPlayer()
    {
        if let localBirdSoundLocation = self.birdSoundLocation {
            self.audioPlayer = SoundPlayer(birdSoundLocation: localBirdSoundLocation)
            //init the Player to get file properties to set the time labels
            
            if let localAudioPlayer = self.audioPlayer {
                
                let durationTimeInterval = localAudioPlayer.getAudioDuration()
                self.currentTimeSlider.maximumValue = Float(durationTimeInterval)
                
                //init the current timedisplay and the labels. if a current time was stored
                //for this player then take it and update the time display
                self.timeElapsed.text = Constants.InitialTimeString;
                
                self.timeLeft.text = "-" + (self.stringFromTimeInterval(durationTimeInterval) as String)
                
                let imageNamed = self.birdSoundLocation?.imageFile
 
                if let localImageNamed = imageNamed {
                    let image = UIImage(named: localImageNamed, inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil)
                    if let localImage = image {
                        self.imageView.image = localImage
                    }
                }

                //        let volume = self.audioPlayer?.getVolume()
                //        self.volumeSlider.value = volume!
                
            } else {
                
                // error message should be displayed
                self.timeElapsed.text = Constants.InitialTimeString
                self.timeLeft.text = Constants.InitialTimeString
                self.playButton.enabled = false
                self.currentTimeSlider.enabled = false
            }
        }
    }
    
    func setupViewLabels() {
        if let localBirdSoundLocation = self.birdSoundLocation {

            self.birdNameLabel.text = localBirdSoundLocation.name
            self.recordedDateLabel.text = localBirdSoundLocation.date
        }
    }
    
    func updateTime(timer: NSTimer) {
        if !self.dragging {
            let currentTime = self.audioPlayer?.getCurrentAudioTime()
            let currentTimeFloat = Float(currentTime!)
            self.currentTimeSlider.value = currentTimeFloat
        }
        
        let currentTime = self.audioPlayer?.getCurrentAudioTime()
        self.timeElapsed.text = self.stringFromTimeInterval(currentTime!) as String
        
        let durationTime = self.audioPlayer?.getAudioDuration()
        var duration = durationTime! - currentTime!
        self.timeLeft.text = "-" + (self.stringFromTimeInterval(duration) as String)
        
        if let localAudioPlayer = self.audioPlayer {
            if !localAudioPlayer.isPlaying() {
                self.playButton?.setBackgroundImage(UIImage(named: Constants.PlayButtonImageFileName), forState: UIControlState.Normal)
                
                self.audioPlayer?.pauseAudio()
                self.paused = true
            }
        }
    }
    
    //    @IBAction func volume(sender: UISlider) {
    //        self.audioPlayer?.setVolume(self.volumeSlider.value)
    //    }
    
    @IBAction func setCurrentTime(sender: UISlider) {

        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "updateTime:", userInfo: nil, repeats: false)
        let currentTime = NSTimeInterval(self.currentTimeSlider.value)
        self.audioPlayer?.setCurrentAudioTime(currentTime)
        self.dragging = false
        
    }
    
    @IBAction func userIsDragging(sender: UISlider) {
        self.dragging = true
    }
    
    @IBAction func playAudioPressed(sender: UIButton) {
        
        //play audio for the first time or if pause was pressed
        if self.paused {
            self.playButton?.setBackgroundImage(UIImage(named: Constants.PauseButtonImageFileName), forState: UIControlState.Normal)
            
            //start a timer to update the time label display
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "updateTime:", userInfo: nil, repeats: true)
            self.audioPlayer?.playAudio()
            self.paused = false
            
        } else {
            //player is paused and Button is pressed again
            self.playButton?.setBackgroundImage(UIImage(named: Constants.PlayButtonImageFileName), forState: UIControlState.Normal)
            self.timer?.invalidate()
            self.audioPlayer?.pauseAudio()
            self.paused = true
        }
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> NSString {
        
        var time = NSInteger(interval)
        var seconds = time % 60
        var minutes = (time / 60) % 60
        return NSString(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    @IBAction func setFinalAudioRate(sender: UISlider) {
        let senderValue = sender.value
        var rateValue = senderValue * 0.5
        self.audioPlayer?.setAudioRate(rateValue)
        
    }
    
    @IBAction func setAudioRate(sender: UISlider) {
        let senderValue = sender.value
        var rateValue = senderValue * 0.5
        //        self.audioPlayer?.setAudioRate(rateValue)

    }
}
