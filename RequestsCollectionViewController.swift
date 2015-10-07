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

class RequestsCollectionViewController: UICollectionViewController {
    
    
    var requests = [Request]()
    var requestsByLocaion = [String:[Request]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadRequests()
        setupNavBar()
        collectionView?.backgroundColor = UIColor.whiteColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(animated: Bool) {
//        loadRequests()
//    }
    
    override func viewDidAppear(animated: Bool) {
        loadRequests()
    }
    
    func setupNavBar() {
        let backItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    // MARK: Helper Methods
    
    func loadRequests() {
        let query = Request.query()
        query?.includeKey("creatorUser")
        query?.orderByDescending("createdAt")
        query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.requests = objects as! [Request]
                    for request in self.requests {
                        if var locArray = self.requestsByLocaion[request.deliverLocation] {
                            locArray.append(request)
                            self.requestsByLocaion[request.deliverLocation] = locArray
                            
                        } else {
                            var locArray = [Request]()
                            locArray.append(request)
                            self.requestsByLocaion[request.deliverLocation] = locArray
                        }
                    }
                    
                    self.collectionView?.reloadData()
                }
            }
        })
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
        
        let request = requests[indexPath.item]
        
        cell.itemTitle.text = request.itemTitle
        cell.itemCost.text = String(format: "%.2f", request.itemCost)
        cell.itemImage.image = UIImage(named: "defaultPhoto")
        if let itemPhoto = request.itemImage {
            itemPhoto.getDataInBackgroundWithBlock { data, error in
                
                if cell == collectionView.cellForItemAtIndexPath(indexPath){
                    if let newData = data {
                        cell.itemImage.image = UIImage(data: newData)
                    }
                }
                
            }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destinationViewController as! RequestDetailViewController
            if let selectedRequestCell = sender as? RequestCollectionViewCell {
                if let indexPath = collectionView?.indexPathForCell(selectedRequestCell){
                    let selectedRequest = requests[indexPath.item]
                    detailVC.request = selectedRequest
                }

            }
        }
        
    }
    
}
