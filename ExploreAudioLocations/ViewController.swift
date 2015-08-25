//
//  ViewController.swift
//  ExploreAudioLocations
//
//  Created by Wesley Sadler on 7/16/15.
//  Copyright (c) 2015 Digital Sadler. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Constants
    
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let AnnotationViewReuseIdentifier = "soundlocation"
        static let PlaySoundSegue = "Play Sound"
    }

    private struct InitialMapLocationConstants {
        static let latitude = 41.963231
        static let longitude = -87.633608
        // in meters
        static let span: CLLocationDistance = 500
    }

    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Satellite
            mapView.delegate = self
        }
    }

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupInitialMapLocation()
        self.addInitialAnnotations()
    }

    private func setupInitialMapLocation() {

        // set initial location Montrose Point Chicago
        let initialLocation = CLLocation(latitude: InitialMapLocationConstants.latitude, longitude: InitialMapLocationConstants.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, InitialMapLocationConstants.span * 1.0, InitialMapLocationConstants.span * 1.0)
        self.mapView.setRegion(coordinateRegion, animated: true)

    }
    
    private func addInitialAnnotations() {
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0), {
            
            ModelController.getBirdSoundLocations { (soundLocations: [BirdSoundLocation], error: NSError? ) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if let localError = error {
                        let alertMessage = UIAlertController(title: "Error Getting Bird Sound Locations", message: error?.description, preferredStyle: .Alert)
                        alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alertMessage, animated: true, completion: nil)
                        
                    } else {
                        self.handleAudioAnnotations(soundLocations)
                    }
                }
            }
        })
    }

    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let birdSoundLocation = annotation as? BirdSoundLocation {
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
                view.canShowCallout = true
                
            }
            
            view.pinColor = birdSoundLocation.pinColor()
            
            view.leftCalloutAccessoryView = nil
            view.rightCalloutAccessoryView = nil

            if birdSoundLocation.imageFile != nil {
                view.leftCalloutAccessoryView = UIImageView(frame: Constants.LeftCalloutFrame)
            }
            if birdSoundLocation.soundFile != nil {
                view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            }

            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        if let birdSoundLocation = view.annotation as? BirdSoundLocation {
            if let thumbnailImageView = view.leftCalloutAccessoryView as? UIImageView {
                
                let imageNamed = UIImage(named: birdSoundLocation.imageFileThumbnail)
                thumbnailImageView.image = imageNamed
                
            }
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        performSegueWithIdentifier(Constants.PlaySoundSegue, sender: view)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.PlaySoundSegue {
            if let birdSoundLocation = (sender as? MKAnnotationView)?.annotation as? BirdSoundLocation {
                if let soundViewController = segue.destinationViewController as? SoundViewController {
                    soundViewController.birdSoundLocation = birdSoundLocation
                }
            }
        }
    }

    // MARK: - Annotations
    
    private func clearAudioAnnotations() {
        if self.mapView?.annotations != nil {
            self.mapView.removeAnnotations(self.mapView.annotations as! [MKAnnotation])
        }
    }
    
    private func handleAudioAnnotations(annotations: [BirdSoundLocation]) {
        self.mapView.addAnnotations(annotations)
        // if map was not static use this to reposition the map to show pins
//        self.mapView.showAnnotations(annotations, animated: true)
    }

}

