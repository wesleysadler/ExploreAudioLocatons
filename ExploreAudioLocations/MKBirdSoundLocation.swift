//
//  MKBirdSoundLocation.swift
//  ExploreAudioLocations
//
//  Created by Wesley Sadler on 7/16/15.
//  Copyright (c) 2015 Digital Sadler. All rights reserved.
//

import Foundation
import MapKit

extension BirdSoundLocation: MKAnnotation {
    
    private struct Constants {
        static let Alarm = "Alarm"
        static let Chip = "Chip"
        static let Call = "Call"
        static let Song = "Song"
    }
    
    // MARK: - MKAnnotation
    
    @objc var coordinate: CLLocationCoordinate2D {
        var locationComponents = location.componentsSeparatedByString(",")

        var latitudeString = locationComponents[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var latitude = NSNumberFormatter().numberFromString(latitudeString)?.doubleValue
        
        var longitudeString = locationComponents[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var longitude = NSNumberFormatter().numberFromString(longitudeString)?.doubleValue
       
        
        return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
    
    var title: String! { return name }
    
    var subtitle: String! { return date }

    func pinColor() -> MKPinAnnotationColor  {
        switch soundType {
        case Constants.Alarm:
            return .Red
        case Constants.Call, Constants.Chip:
            return .Purple
        case Constants.Song:
            return .Green
        default:
            return .Green
        }
    }
    
}
