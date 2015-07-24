//
//  BirdSoundLocation.swift
//  ExploreAudioLocations
//
//  Created by Wesley Sadler on 7/16/15.
//  Copyright (c) 2015 Digital Sadler. All rights reserved.
//

import Foundation

class BirdSoundLocation: NSObject {
    
    // Latatude Longitude, Elevation
    let location:String!
    let name:String!
    let imageFile:String!
    let imageFileThumbnail:String!
    // Song, Chip, Call, Alarm
    let soundType:String!
    let soundFile:String!
    let recordist:String!
    let date:String!
    
    
    init(location:String, name:String, imageFile: String, imageFileThumbnail:String, soundType:String, soundFile:String, recordist:String, date:String) {
        
        self.location = location
        self.name = name
        self.imageFile = imageFile
        self.imageFileThumbnail = imageFileThumbnail
        self.soundType = soundType
        self.soundFile = soundFile
        self.recordist = recordist
        self.date = date
        super.init()
    }
    
    override var description: String {
        return "Name: \(name), Location: \(location)\n"
    }

}
