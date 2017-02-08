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

enum TransportationType: Int
{
    case Walk
    case Bike
    case Car
    
}

extension Bathroom: MKAnnotation
{
    public var title: String?
    {
        switch gender
        {
        case 0:
            return "Female"
        case 1:
            return "Male"
        case 2:
            return "Female/Male"
        case 3:
            return "All"
        default:
            return ""
        }
    }
    public var subtitle: String?
    {
        switch bathroomType
        {
        case 0:
            return "Public"
        case 1:
            return "Portalet"
        case 2:
            return "Customers Only"
        case 3:
            return "Employees Only"
        default:
            return ""
        }
    }
    public var coordinate: CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var transportationDirectionsSegment: UISegmentedControl!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var allBathrooms = [Bathroom]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //HNS - best accuracy for user, need permission from user when app in use, and when user is going to bathroom, update. See function below.
        configureLocationManager()
        bathroomDirections()
        
}//end of viewDidLoad
    
        
//MARK: ModalLoginSegue for LoginViewController to dismiss upon login.
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if !AppState.sharedInstance.signedIn
        {
           performSegue(withIdentifier: "ModalLoginSegue", sender: self)
        }
        
        mapView.removeAnnotations(allBathrooms)
        allBathrooms.removeAll()
        
        let fetchAllBathroomsRequest: NSFetchRequest<Bathroom> = Bathroom.fetchRequest()
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try managedObjectContext.fetch(fetchAllBathroomsRequest)
            allBathrooms = results
            mapView.addAnnotations(allBathrooms)
        } catch
        {
            print(error.localizedDescription)
        }
        
       // mapView?.delegate = self
       // mapView?.addAnnotations(Bathroom)
        
      //  let overlays = Bathroom.map
    //fetch bathrooms from coredata. create function first then call it in this area. the function will include the bathroom objects and turn them into my X's
        
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
           locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            if status == .notDetermined
            {
                locationManager.requestWhenInUseAuthorization()
            }
            else if status == .authorizedWhenInUse
            {
                locationManager.startUpdatingLocation()
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
        //self.locationManager.stopUpdatingLocation()
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

    //HNS - Callout - customized http://sweettutos.com/2016/01/21/swift-mapkit-tutorial-series-how-to-customize-the-map-annotations-callout-request-a-transit-eta-and-launch-the-transit-directions-to-your-destination/

    
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
            
            let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            //rightButton.addTarget(mapView, action: #selector(getDirections), for: .touchUpInside)
            rightButton.setTitle("GO", for: .normal)
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
        //coordinates += CLLocationCoordinate2D(latitude:  , longitude: -81.37760925292969)]
        //coordinates += [restaurants[10].coordinate] //Uno's
        let path = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        mapView.add(path)
    }
    //HNS - line from user to bathroom selected.
    private func mapView(_ mapView: MKMapView, rendererfor overlay: MKOverlay) -> MKOverlayRenderer
    {   /*
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor(hue: 185/360, saturation: 54/100, brightness: 65/100, alpha: 1.0)
            polylineRenderer.lineWidth = 2
            return polylineRenderer
            */
        
        if overlay is MKPolyline
        {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor(hue: 185/360, saturation: 54/100, brightness: 65/100, alpha: 1.0)
        polylineRenderer.lineWidth = 2
        return polylineRenderer
        }
        return overlay as! MKOverlayRenderer
    }
    
    //HNS - bathroom address info on MapView and sending to BathroomAddedTVC
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
   {
       if segue.identifier == "TagBathroomSegue"
       {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! BathroomAddedTableViewController
        
        
        let info: [String: AnyObject] = [
            "latitude": currentLocation!.coordinate.latitude as AnyObject,
            "longitude": currentLocation!.coordinate.longitude as AnyObject,
            "address": addressLabel.text! as AnyObject
        ]
        
        controller.bathroomLocationInfo = info
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
   /*
    func getDirections(_ sender: UIButton)
    {
    currentLocation
    }
    */
//MARK: IBActions
    
  /*
    @IBAction func transportationDirectionsSegmentButtons(_ sender: UISegmentedControl)
    {
        let transportationType = MKDirectionsRequest(rawValue: transportationDirectionsSegment.selectedSegmentIndex)
        switch (transportationType!) {
        case .Walk:
            MKDirections.transportationType = .Walk
        case .Bike:
            .transportationType = TransportationType.Bike
        case .Car:
            .transportationType = TransportationType.Car
        }
    }
       */
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
