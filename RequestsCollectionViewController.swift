//
//  RequestsCollectionViewController.swift
//  PickUP
//
//  Created by Derrick Park on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

import UIKit
import Parse
import Bolts

private let reuseIdentifier = "Cell"

extension PFGeoPoint {
    public var cllocation: CLLocation {
        get {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
    }
}

class RequestsCollectionViewController: UICollectionViewController, AddRequestViewContollerDelegate, RequestDetailViewControllerDelegate, LocationManagerDelegate {
    
    
    var requests = [Request]()
    var requestsByLocaion = [String:[Request]]()
    var currentLoc: CLLocation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationManager = LocationManager.sharedLocationManager()
        locationManager.delegate = self
        LocationManager.sharedLocationManager().startLocationManager(self)
        
        // force a location update immediately
        updateLocation(locationManager.currentLocation)

        setupNavBar()
        collectionView?.backgroundColor = UIColor.whiteColor()
        
    }
    
    // MARK: LocationManagerDelegate 
    
    func updateLocation(currentLocation: CLLocation!) {
        
        if self.currentLoc == nil && currentLocation != nil {
            self.currentLoc = currentLocation
            loadRequests()
        }
    }

    // MARK: Helper Methods
    
    func calculateDistance (currentLocation: CLLocation!) {
        for request in requests {
            let distance = request.pickupLocation.coordinate.cllocation.distanceFromLocation(currentLocation)
            request.distanceFromPickupLoc = distance
            print("distance between \(request.pickupLocation.location) and me is \(distance)")
        }
    }
    
    func setupNavBar() {
        let backItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func didAddNewItem(newRequest:Request) {
        
        let distance = newRequest.pickupLocation.coordinate.cllocation.distanceFromLocation(currentLoc!)
        newRequest.distanceFromPickupLoc = distance
        
        if var requestArray = self.requestsByLocaion[newRequest.cityName] {
            
            requestArray.append(newRequest)
            self.requestsByLocaion[newRequest.cityName] = requestArray
            
        } else {
            
            self.requestsByLocaion[newRequest.cityName] = [newRequest]
        }
        
        self.collectionView?.reloadData()
        
    }

    func didAcceptRequest() {
        removeAcceptedObject()
        self.collectionView?.reloadData()
        
    }
    
    func removeAcceptedObject() {
        
        requests = requests.filter { (item: Request)->(Bool) in !item.isAccepted }

        sortIntoDictionary(requests)
        
    }
    
    func loadRequests() {
        let query = Request.query()
        query?.includeKey("creatorUser")
        query?.includeKey("pickupLocation")
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.requests = objects as! [Request]
                    self.calculateDistance(self.currentLoc)
                    self.sortIntoDictionary(self.requests)
                    self.collectionView?.reloadData()
                }
            }
        })
    }
    
    func sortIntoDictionary(requests: [Request]) {
        if requests.count == 0 {
            self.requestsByLocaion = [String: [Request]]()
        }
        
        for request in requests {
            
            if let city = request.cityName {
                if var locArray = self.requestsByLocaion[city] {
                    locArray.append(request)
                    self.requestsByLocaion[city] = locArray
                    
                } else {
                    var locArray = [Request]()
                    locArray.append(request)
                    self.requestsByLocaion[city] = locArray
                }
            }
            
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return requestsByLocaion.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let keys = Array(requestsByLocaion.keys)
        let currentKey = keys[section]
        
        return requestsByLocaion[currentKey]!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RequestCollectionViewCell
        
        let citiesArray = [String](requestsByLocaion.keys)
        let myRequestsByCity = citiesArray[indexPath.section]
        
        if let requestsArray = requestsByLocaion[myRequestsByCity] {
            
            cell.object = requestsArray[indexPath.row]
            
        }
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView =
            collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: "RequestsHeaderView",
                forIndexPath: indexPath)
                as! RequestsHeaderView
            
            let keys = Array(requestsByLocaion.keys)
            let currentKey = keys[indexPath.section]
            headerView.locationLabel.text = currentKey
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destinationViewController as! RequestDetailViewController
            if let selectedRequestCell = sender as? RequestCollectionViewCell {
                if let indexPath = collectionView?.indexPathForCell(selectedRequestCell) {
                    
                    let citiesArray = [String](requestsByLocaion.keys)
                    let myRequestsByCity = citiesArray[indexPath.section]
                    if let requestsArray = requestsByLocaion[myRequestsByCity] {
                        
                        let selectedRequest = requestsArray[indexPath.row]
                        detailVC.request = selectedRequest
                        detailVC.object = selectedRequestCell
                        detailVC.delegate = self
                    }
                }

            }
        } else if segue.identifier == "addPost" {
            let nav = segue.destinationViewController as! UINavigationController
            let addPostVC = nav.topViewController as! AddRequestViewController
            addPostVC.delegate = self
        }
        
    }
    
}
