//
//  MapViewController.swift
//  TwoP
//
//  Created by HSummy on 1/23/17.
//  Copyright © 2017 HSummy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

//HNS - Version 2 will incorporate GeoCoder for more accurate location inside buildings since phone will use phone towers instead of GPS, when GPS in not available.
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
   
{
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //HNS - best accuracy for user, need permission from user when app in use, and when user is going to bathroom, update. See function below.
        configureLocationManager()
        bathroomDirections()
        
        


        // hard coded bathrooms below
       /* let bathroomTIYGeneral = CLLocationCoordinate2D(latitude: 28.5412382, longitude: -81.381044)
        let bathroomTIYGeneralAnnotation = MKPointAnnotation()
        bathroomTIYGeneralAnnotation.coordinate = bathroomTIYGeneral
        bathroomTIYGeneralAnnotation.title = "2P"
        bathroomTIYGeneralAnnotation.subtitle = "TIY E"
        
        let bathroomDrPhillips = CLLocationCoordinate2D(latitude: 28.537654876708984, longitude: -81.37760925292969)
        let bathroomDrPhillipsAnnotation = MKPointAnnotation()
        bathroomDrPhillipsAnnotation.coordinate = bathroomDrPhillips
        bathroomDrPhillipsAnnotation.title = "2P"
        bathroomDrPhillipsAnnotation.subtitle = "Dr.Phillips W"
        
        let bathroomCowboys = CLLocationCoordinate2D(latitude: 28.529212951660156, longitude: -81.39728546142578)
        let bathroomCowboysAnnotation = MKPointAnnotation()
        bathroomCowboysAnnotation.coordinate = bathroomCowboys
        bathroomCowboysAnnotation.title = "2P"
        bathroomCowboysAnnotation.subtitle = "Cowboys W"
        
        let bathroomCanvs = CLLocationCoordinate2D(latitude: 28.541330337524414, longitude: -81.38108825683594)
        let bathroomCanvsAnnotation = MKPointAnnotation()
        bathroomCanvsAnnotation.coordinate = bathroomCanvs
        bathroomCanvsAnnotation.title = "2P"
        bathroomCanvsAnnotation.subtitle = "Canvs W"

            mapView.showAnnotations([bathroomTIYGeneralAnnotation, bathroomDrPhillipsAnnotation, bathroomCowboysAnnotation, bathroomCanvsAnnotation], animated: true)
        */
        
        
        
        
       //HNS - Do I need this for my first version as I am not worried about addresses at this point????????
       /* let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString("Orlando, FL", completionHandler:
            {
                placemarks, error in
                if let geocodeError = error
                {
                    print(geocodeError.localizedDescription)
                }
                   else
                    {
                        if let placemark = placemarks?[0]
                        {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = (placemark.location?.coordinate)!
                        self.mapView.addAnnotation(annotation)
                        }
                    }
            })*/
        

        
}//end of viewDidLoad
    
        
//MARK: ModalLoginSegue for LoginViewController to dismiss upon login.
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if !AppState.sharedInstance.signedIn
        {
           performSegue(withIdentifier: "ModalLoginSegue", sender: self)
        }
    }


    
//MARK: Location functions
    //HNS- asking status and if granted, start acquiring best accuracy.
  func configureLocationManager()
    {
        let status = CLLocationManager.authorizationStatus()
        if status != .denied && status != .restricted
        {
           locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if status == .notDetermined
            {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
        }
        else
        {
            print("User denied access to their Location!")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error.localizedDescription)
    }
    
    //HNS - created function to track user location in the array called locations https://www.youtube.com/watch?v=UyiuX8jULF4
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //HNS - access the most recent location (i.e. last location)
        currentLocation = locations[0]
        
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLocation!.coordinate.latitude, currentLocation!.coordinate.longitude)
        
        //HNS - how close we want to track
        let userZoomAccuracy: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        //HNS - combines the user location and the span(zoom) to get the general region.
        let userRegion: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, userZoomAccuracy)
        //HNS - setting the map
        mapView.setRegion(userRegion, animated: true)
        
        //HNS - stop updating when not in use.
        self.locationManager.stopUpdatingLocation()
        
        //HNS-below line is same as User Location in Storyboard, but done programmically.
        mapView?.showsUserLocation = true
        //HNS - getting Lat and Long and coverting to address and displaying it on label below map.
        CLGeocoder().reverseGeocodeLocation(currentLocation!)
        {
        (placemark, error) in
            if error != nil
            {
                print ("There is an error in Geocoding")
            }
            else
            {
                if let place = placemark?[0]
                {
                    if place.location != nil
                    {
                    self.addressLabel.text = "\(place.name!) \n \(place.subThoroughfare!) \(place.thoroughfare!) \n \(place.locality!), \(place.administrativeArea!).  \(place.postalCode!)"
                    }
                }
            }
        }

        
        //HNS - add annotation to the popup on the map with information ---------need to add from my custompinannotation class when i am done.
        //pinAnnotation = CustomPin()
        //pinAnnotation.pinCustomImageName = "x"
        
        
       
       
       // HNS - annotation.subtitle = "(put in OPEN - 2PNOW = based on MFE, Public, hours)"
        //pinAnnotationView = MKPinAnnotationView(annotation: pinAnnotation as! MKAnnotation?, reuseIdentifier: "pin")
       // mapView.addAnnotation(pinAnnotationView.annotation!)
    
    }
    //HNS - Annotations - callouts
    //func mapItem() -> MKMapItem
   // {
    //    let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
     //   let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
     //   let mapItem = MKMapItem(placemark: placemark)
     //   mapItem.name = title
    
     //   return mapItem
   // }
    

    //HNS - Callout - customized http://sweettutos.com/2016/01/21/swift-mapkit-tutorial-series-how-to-customize-the-map-annotations-callout-request-a-transit-eta-and-launch-the-transit-directions-to-your-destination/
    
   // extension MapViewController: MKMapViewDelegate {
      //  func mapView(_ mapView: MKMapView,
      //               viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
           // guard annotation is Location else {
           //     return nil
           // }
            
            //let identifier = "Location"
            //var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            //if annotationView == nil {
              //  let pinView = MKPinAnnotationView(annotation: annotation,
               //                                   reuseIdentifier: identifier)
               // pinView.isEnabled = true
                //pinView.canShowCallout = true

                
       //         let rightButton = UIButton(type: .detailDisclosure)
       //         rightButton.addTarget(self,
        //                              action: #selector(showLocationDetails),
        //                              for: .touchUpInside)
         //       pinView.rightCalloutAccessoryView = rightButton
                
         //       annotationView = pinView
         //   }
            
           // if let annotationView = annotationView {
           //     annotationView.annotation = annotation
                
            //    let button = annotationView.rightCalloutAccessoryView as! UIButton
            //    if let index = locations.index(of: annotation as! Location) {
            //        button.tag = index
             //   }
          //  }
            
          //  return annotationView
       // }
    //}
    
//MARK: - Callout
    //HNS - Customized Pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        //HNS - do not make the X pin replace the user's image (bluedot).
        if (annotation is MKUserLocation)
        {
            return nil
        }
        let identifier = "2Pi"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil
        {
            let annotationBathroomLocationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationBathroomLocationView.isEnabled = true
            annotationBathroomLocationView.canShowCallout = true
            annotationBathroomLocationView.image = UIImage(named: "x")
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(mapView, action: #selector(showBathroomLocationDetails), for: .touchUpInside)
            annotationBathroomLocationView.rightCalloutAccessoryView = rightButton
            annotationView = annotationBathroomLocationView
        }else{
            annotationView?.annotation = annotation
        }
        
       // configureBathroomDetailAnnotationView(annotationView: annotationView!)
        
        return annotationView
    }
    //HNS - !!!come back to this for the call out. i button
    func showBathroomLocationDetails(sender: UIButton)
    {
        performSegue(withIdentifier: "2Pi", sender: sender)
    }
    
    
//MARK: Map Overlay - directions to X using ploylines
    //!!!HNS - https://makeapppie.com/2016/05/16/adding-annotations-and-overlays-to-maps/ - need to finish the 'directions' to the bathroom with black line.
    
    func bathroomDirections()
    {
        var coordinates = [CLLocationCoordinate2D]()
        //coordinates += [ChicagoCenterCoordinate().coordinate] //State and Washington
        coordinates += [CLLocationCoordinate2D(latitude: 28.537654876708984, longitude: -81.37760925292969)]
        //coordinates += [restaurants[10].coordinate] //Uno's
        let path = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        mapView.add(path)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.black
            polylineRenderer.lineWidth = 2
            return polylineRenderer
    }
    
    
    
    
    
    
    
    
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
   {
       if segue.identifier == "TagBathroomSegue"
       {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! BathroomAddedTableViewController
        controller.bathroomLocationInfo = ["latitude": "\(currentLocation!.coordinate.latitude)", "longitude": "\(currentLocation!.coordinate.longitude)","address": addressLabel.text!]
        }
   }


 
 
   /*
    func configureBathroomAnnotationView (annotationView: MKAnnotationView)
    {
        let bathroomLabelAnnotation = annotation as! MKUserLocation
        //annotationView?.detailCalloutAccessoryView = UIImageView(image: bathroomAnnotation.image)
                //HNS - Left label top
        let leftLabelTop = UILabel(frame: CGRect(0,0,50,30))
        leftLabelTop.font = UIFont(name: "Verdana", size: 10)
        annotationView?.leftCalloutLabelTopView = leftLabelTop
        
        //HNS - Left label bottom
        let leftLabelBottom = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        leftLabelBottom.font = UIFont(name: "Verdana", size: 10)
        annotationView. = leftLabelBottom
        
        //HNS - Right label top
        let rightLabelTop = UILabel(frame: CGRect(0,0,50,30))
        rightLabelTop.font = UIFont(name: "Verdana", size: 10)
        annotationView.rightCalloutLabelTopView = rightLabelTop
        
        // Right accessory view
        //let image = UIImage(named: "star.png")
        let rightButton = UIButton(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //button.setImage(image, for: .normal)
        annotationView.rightCalloutAccessoryView = rightButton
        return annotationView
    }
 */
   
    
     
       
    
    

    
//MARK: IBActions
    //HNS - tag button will 'pin' the bathroom and open the Tag Bathroom TVC with prepare segue function - Modal.

        
        
        
        /*override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            if segue.identifier == "TagBathroomSegue"
            {
                let navigationController = segue.destination as! UINavigationController
                let controller = navigationController.topViewController as! BathroomAddedTableViewController
                
                controller.coordinate = location!.coordinate
                controller.placemark = placemark
                controller.managedObjectContext = managedObjectContext
            }
        }
 
    }
    */
    

}//end of MapViewerController class
