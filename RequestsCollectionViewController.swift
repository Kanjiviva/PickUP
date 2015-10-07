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

class RequestsCollectionViewController: UICollectionViewController, AddRequestViewContollerDelegate {
    
    
    var requests = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRequests()
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
    
//    override func viewDidAppear(animated: Bool) {
//        loadRequests()
//    }
    
    func setupNavBar() {
        let backItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func didAddNewItem() {
        
        loadRequests()
    }
    
    // MARK: Helper Methods
    
    func loadRequests() {
        let query = Request.query()
        query?.includeKey("creatorUser")
        query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    self.requests = objects as! [Request]
                    self.collectionView?.reloadData()
                }
            }
        })
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return requests.count
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
            headerView.locationLabel.text = "Vancouver"
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
        } else if segue.identifier == "addPost" {
            let nav = segue.destinationViewController as! UINavigationController
            let addPostVC = nav.topViewController as! AddRequestViewController
            addPostVC.delegate = self
        }
        
    }
    
}
