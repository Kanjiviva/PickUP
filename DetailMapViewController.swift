//
//  DetailMapViewController.swift
//  PickUP
//
//  Created by Derrick Park on 2015-10-09.
//  Copyright © 2015 Steve. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class DetailMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, LocationManagerDelegate {
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    @IBOutlet weak var estimatedDistanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var myRoute: MKRoute?
    var request: Request?
    let pickupLoc = MKPointAnnotation()
    let dropoffLoc = MKPointAnnotation()
    var currentLoc: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPins()
      
        let locationManager = LocationManager.sharedLocationManager()
        locationManager.delegate = self
        LocationManager.sharedLocationManager().startLocationManager(self)
        myMapView.delegate = self

        currentLoc = locationManager.currentLocation
        self.addressLabel.text = "Current Location"
        
    }
    
    // MARK: LocationManagerDelegate
    
    func updateLocation(currentLocation: CLLocation!) {
      
        var region = MKCoordinateRegion.init()
        var span = MKCoordinateSpan.init()
     
        region.center.latitude = currentLocation.coordinate.latitude;
        region.center.longitude = currentLocation.coordinate.longitude;
        
        span.latitudeDelta = myMapView.region.span.latitudeDelta / 7000;
        span.longitudeDelta = myMapView.region.span.longitudeDelta / 7000;
        region.span = span
        myMapView.setRegion(region, animated: true)
        
    }
    
    // MARK: Helper
    
    func setUpPins() {
        
        pickupLoc.coordinate = (request?.pickupLocation.coordinate.cllocation.coordinate)!
        pickupLoc.title = "Pick Up"
        pickupLoc.subtitle = (request?.pickupLocation.location)!
        myMapView.addAnnotation(pickupLoc)
        
        dropoffLoc.coordinate = (request?.delCoordinate.cllocation.coordinate)!
        dropoffLoc.title = "Drop Off"
        dropoffLoc.subtitle = request?.deliverLocation
        myMapView.addAnnotation(dropoffLoc)
    }
    
    func zoomingMapView(firstPoint:MKPointAnnotation, secondPoint: MKPointAnnotation) {
        let pickUpPoint = MKMapPointForCoordinate(firstPoint.coordinate)
        let dropOffPoint = MKMapPointForCoordinate(secondPoint.coordinate)
        
        let pickUpRect = MKMapRectMake(pickUpPoint.x-30000, pickUpPoint.y-30000, 0.1, 0.1)
        let dropOffRect = MKMapRectMake(dropOffPoint.x, dropOffPoint.y, 30000, 30000)
        
        let unionRect = MKMapRectUnion(pickUpRect, dropOffRect);
        
        myMapView.setVisibleMapRect(unionRect, animated: true)
        
    }
    
    func zoomingMapViewFromCurrentUser(with destinationPoint: MKPointAnnotation) {
        
        let currentPoint = MKMapPointForCoordinate((currentLoc?.coordinate)!)
        let dropOffPoint = MKMapPointForCoordinate(destinationPoint.coordinate)
        
        let currentRect = MKMapRectMake(currentPoint.x-30000, currentPoint.y-30000, 0.1, 0.1)
        let dropOffRect = MKMapRectMake(dropOffPoint.x, dropOffPoint.y, 30000, 30000)
        
        let unionRect = MKMapRectUnion(currentRect, dropOffRect);
        
        myMapView.setVisibleMapRect(unionRect, animated: true)
        
    }
    
    func directionRequest(firstPoint:MKPointAnnotation, secondPoint: MKPointAnnotation) {
        
        let directionsRequest = MKDirectionsRequest()
        let markPickUp = MKPlacemark(coordinate: CLLocationCoordinate2DMake(firstPoint.coordinate.latitude, firstPoint.coordinate.longitude), addressDictionary: nil)
        
        let markDropOff = MKPlacemark(coordinate: CLLocationCoordinate2DMake(secondPoint.coordinate.latitude, secondPoint.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem.init(placemark: markPickUp)
        directionsRequest.destination = MKMapItem.init(placemark: markDropOff)
        directionsRequest.transportType = MKDirectionsTransportType.Automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse?, error: NSError?) -> Void in
            
            if error == nil {
                self.myRoute = response!.routes[0] as MKRoute
                self.myMapView.addOverlay((self.myRoute?.polyline)!)
                self.estimatedTimeLabel.text = String(format: "%.f min", ((self.myRoute?.expectedTravelTime)! / 60))
                self.estimatedDistanceLabel.text = String(format: "%.1f Km" ,(self.myRoute?.distance)! / 1000)
            }
        }

    }
    
    func directionRequestFromCurrentUser(to destinationPoint: MKPointAnnotation) {
        
        let directionsRequest = MKDirectionsRequest()
       
        let markDropOff = MKPlacemark(coordinate: CLLocationCoordinate2DMake(destinationPoint.coordinate.latitude, destinationPoint.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem.mapItemForCurrentLocation()
        directionsRequest.destination = MKMapItem.init(placemark: markDropOff)
        directionsRequest.transportType = MKDirectionsTransportType.Automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse?, error: NSError?) -> Void in
            
            if error == nil {
                self.myRoute = response!.routes[0] as MKRoute
                self.myMapView.addOverlay((self.myRoute?.polyline)!)
                self.estimatedTimeLabel.text = String(format: "%.f min", ((self.myRoute?.expectedTravelTime)! / 60))
                self.estimatedDistanceLabel.text = String(format: "%.1f Km" ,(self.myRoute?.distance)! / 1000)
            }
        }
        
    }
   
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let myLineRenderer = MKPolylineRenderer(polyline: (myRoute?.polyline)!)
        myLineRenderer.strokeColor = UIColor.redColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }
    
    // MARK: Action 
    
    @IBAction func routeChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            if (self.myRoute != nil) {
                self.myMapView.removeOverlay((self.myRoute?.polyline)!)
            }
            self.addressLabel.text = "Current Location"
            self.estimatedDistanceLabel.text = "000 Km"
            self.estimatedTimeLabel.text = "000 min"
            updateLocation(currentLoc)
            
        } else if sender.selectedSegmentIndex == 1 {
            //pickup route from currentLoc
            if (self.myRoute != nil) {
                self.myMapView.removeOverlay((self.myRoute?.polyline)!)
            }
            
            self.locationLabel.text = "Pick Up"
            self.addressLabel.text = pickupLoc.subtitle
            
            zoomingMapViewFromCurrentUser(with: pickupLoc)
            directionRequestFromCurrentUser(to :pickupLoc)
            
        } else if sender.selectedSegmentIndex == 2 {
            //dropOff route from currentLoc
            if (self.myRoute != nil) {
                self.myMapView.removeOverlay((self.myRoute?.polyline)!)
            }
            self.locationLabel.text = "Drop Off"
            self.addressLabel.text = dropoffLoc.subtitle
            zoomingMapViewFromCurrentUser(with: dropoffLoc)
            directionRequestFromCurrentUser(to :dropoffLoc)

        } else {
            //pickup to dropoff route
            if (self.myRoute != nil) {
                self.myMapView.removeOverlay((self.myRoute?.polyline)!)
            }
            self.locationLabel.text = "Route"
            self.addressLabel.text = dropoffLoc.subtitle
            zoomingMapView(pickupLoc, secondPoint: dropoffLoc)
            directionRequest(pickupLoc, secondPoint: dropoffLoc)

        }
        
    }


}
