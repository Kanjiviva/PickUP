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

class RequestsCollectionViewController: UICollectionViewController, AddRequestViewContollerDelegate, RequestDetailViewControllerDelegate {
    
    
    var requests = [Request]()
    var requestsByLocaion = [String:[Request]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRequests()
        setupNavBar()
        collectionView?.backgroundColor = UIColor.whiteColor()
        
    }
    
    func setupNavBar() {
        let backItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func didAddNewItem() {
        
        loadRequests()
    }
    
    func didAcceptRequest() {
        loadRequests()
    }
    
    // MARK: Helper Methods
    
    func removeAcceptedObject() {
        
        for request in requests {
            if request.isAccepted {
                requests.removeAtIndex(requests.indexOf(request)!)
            }
        }
        
    }
    
    func loadRequests() {
        let query = Request.query()
        query?.includeKey("creatorUser")
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.requests = objects as! [Request]
                    
                    self.sortIntoDictionary(self.requests, completionClosure: {
                        self.collectionView?.reloadData()
                    })
                    
                }
            }
        })
    }
    
    func sortIntoDictionary(requests: [Request], completionClosure: () -> ()) {
        
        for (index,request) in requests.enumerate() {
            let locationCoordinate = request.delCoordinate.cllocation
            
            CLGeocoder().reverseGeocodeLocation(locationCoordinate) { (placemarks, error) -> Void in
                
                if let myPlacemarks = placemarks  {
                    
                    let placemark = myPlacemarks[0]
                    
                    if let city = placemark.locality {
                        if var locArray = self.requestsByLocaion[city] {
                            locArray.append(request)
                            self.requestsByLocaion[city] = locArray
                            
                        } else {
                            var locArray = [Request]()
                            locArray.append(request)
                            self.requestsByLocaion[city] = locArray
                        }
                        
                        if index == requests.count - 1 {
                            completionClosure()
                        }
                    }
                
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
        
        cell.object = requests[indexPath.item]
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destinationViewController as! RequestDetailViewController
            if let selectedRequestCell = sender as? RequestCollectionViewCell {
                if let indexPath = collectionView?.indexPathForCell(selectedRequestCell){
                    let selectedRequest = requests[indexPath.item]
                    detailVC.request = selectedRequest
                    detailVC.delegate = self
                }

            }
        } else if segue.identifier == "addPost" {
            let nav = segue.destinationViewController as! UINavigationController
            let addPostVC = nav.topViewController as! AddRequestViewController
            addPostVC.delegate = self
        }
        
    }
    
}
