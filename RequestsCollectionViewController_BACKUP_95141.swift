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
    
    func didAddNewItem(newRequest:Request) {
        
        let citiesArray = [String](requestsByLocaion.keys)
        
        for city in citiesArray {
            
            if newRequest.cityName == city {
                if var locArray = self.requestsByLocaion[city] {
                    locArray.append(newRequest)
                    self.requestsByLocaion[city] = locArray
                    collectionView?.reloadData()
                    
                } else {
                    var locArray = [Request]()
                    locArray.append(newRequest)
                    self.requestsByLocaion[city] = locArray
                    collectionView?.reloadData()
                }
            }
        }
    }
    
    func didAcceptRequest() {
        removeAcceptedObject()
        collectionView?.reloadData()
        
    }
    
    // MARK: Helper Methods
    
    func removeAcceptedObject() {
        
        requests = requests.filter { (item: Request)->(Bool) in !item.isAccepted }

        sortIntoDictionary(requests)
        
    }
    
    func loadRequests() {
        let query = Request.query()
        query?.includeKey("creatorUser")
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.requests = objects as! [Request]
                    
                    self.sortIntoDictionary(self.requests)
                    self.collectionView?.reloadData()
                }
            }
        })
    }
    
    func sortIntoDictionary(requests: [Request]) {
        
        self.requestsByLocaion = [String: [Request]]()
        
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
        
<<<<<<< HEAD
        let citiesArray = [String](requestsByLocaion.keys)
        let myRequestsByCity = citiesArray[indexPath.section]
        
        if let requestsArray = requestsByLocaion[myRequestsByCity] {
            
            cell.object = requestsArray[indexPath.row]
            
        }
        
=======
        if (indexPath.item < requests.count) {
            cell.object = requests[indexPath.item]
        }
>>>>>>> ef35fa243fab100e1e0aa72793fc704a956db62b
        
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
                if let indexPath = collectionView?.indexPathForCell(selectedRequestCell) {
                    
                    let citiesArray = [String](requestsByLocaion.keys)
                    let myRequestsByCity = citiesArray[indexPath.section]
                    if let requestsArray = requestsByLocaion[myRequestsByCity] {
                        
                        let selectedRequest = requestsArray[indexPath.row]
                        detailVC.request = selectedRequest
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
