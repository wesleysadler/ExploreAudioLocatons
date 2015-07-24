//
//  ModelController.swift
//  ExploreAudioLocations
//
//  Created by Wesley Sadler on 7/22/15.
//  Copyright (c) 2015 Digital Sadler. All rights reserved.
//

import Foundation

class ModelController {
    
    private struct Constants {
        static let jsonFileName = "BirdRecordings"
        
        static let Data = "data"
        static let BirdCommonName = "birdCommonName"
        static let Picture = "picture"
        static let File = "file"
        static let Thumbnail = "thumbnail"
        static let Sound = "sound"
        static let SoundType = "type"
        static let Date = "date"
        static let Recorist = "recorist"
        static let Location = "location"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Elevation = "elevation"
    }
    
    class func getDataFromJSONFile(completionHandler: ((data: NSData, error: NSError?) -> Void)) {
     
        let filePath = NSBundle.mainBundle().pathForResource(Constants.jsonFileName,ofType:"json")
        
        var error:NSError?
        if let data = NSData(contentsOfFile:filePath!, options: NSDataReadingOptions.DataReadingUncached, error:&error) {
            completionHandler(data: data, error:error)
        }

    }
    
    class func getBirdSoundLocations(completionHandler: ((soundLocations: [BirdSoundLocation], error: NSError?) -> Void)) {
        
        ModelController.getDataFromJSONFile { (data, error) -> Void in
            
            if let localError = error {
                
                var soundLocations = [BirdSoundLocation]()
                completionHandler(soundLocations: soundLocations, error: error)
                
            } else {
                
                let json = JSON(data: data)
                
                if let soundsLocationsArray = json[Constants.Data].array {
                    
                    var soundLocations = [BirdSoundLocation]()
                    
                    for soundLocationDictionary in soundsLocationsArray {
                        var birdCommonName: String = soundLocationDictionary[Constants.BirdCommonName].string!
                        
                        var pictureImageFile:String = soundLocationDictionary[Constants.Picture][Constants.File].string!
                        var pictureImageThumbnail:String = soundLocationDictionary[Constants.Picture][Constants.Thumbnail].string!
                        
                        var soundType:String = soundLocationDictionary[Constants.Sound][Constants.SoundType].string!
                        var soundDate:String = soundLocationDictionary[Constants.Sound][Constants.Date].string!
                        var soundFile:String = soundLocationDictionary[Constants.Sound][Constants.File].string!
                        var soundRecorist:String = soundLocationDictionary[Constants.Sound][Constants.Recorist].string!
                        
                        var soundLocationLatitude:String = soundLocationDictionary[Constants.Sound][Constants.Location][Constants.Latitude].string!
                        var soundLocationLongitude:String = soundLocationDictionary[Constants.Sound][Constants.Location][Constants.Longitude].string!
                        var soundLocationElevation:String = soundLocationDictionary[Constants.Sound][Constants.Location][Constants.Elevation].string!
                        
                        var soundLocation = soundLocationLatitude + "," + soundLocationLongitude + "," + soundLocationElevation
                        
/*
                        println("Bird Common Name: \(birdCommonName)")
                        println("Bird Picture File: \(pictureImageFile)")
                        println("Bird Picture Thumbnail: \(pictureImageThumbnail)")
                        println("Bird Sound Type: \(soundType)")
                        println("Bird Sound Date: \(soundDate)")
                        println("Bird Sound File: \(soundFile)")
                        println("Bird Sound Recorist: \(soundRecorist)")
                        println("Bird Sound Latitude: \(soundLocationLatitude)")
                        println("Bird Sound Longitude: \(soundLocationLongitude)")
                        println("Bird Sound Elevation: \(soundLocationElevation)")
                        println("Bird Sound Location: \(soundLocation)")
*/
                        var birdSoundLocation = BirdSoundLocation(location: soundLocation, name: birdCommonName, imageFile: pictureImageFile, imageFileThumbnail: pictureImageThumbnail, soundType: soundType, soundFile: soundFile, recordist: soundRecorist, date: soundDate)
                        soundLocations.append(birdSoundLocation)
                    }
                    
                    completionHandler(soundLocations: soundLocations, error: error)
                    
                }
            }
        }
    }
    
    
}