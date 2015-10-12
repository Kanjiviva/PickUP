//
//  RequestDetailViewController.swift
//  PickUP
//
//  Created by Derrick Park on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

import UIKit

protocol RequestDetailViewControllerDelegate {
    func didAcceptRequest()
}

class RequestDetailViewController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickupLoc: UILabel!
    @IBOutlet weak var dropoffLoc: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descripLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    var delegate: RequestDetailViewControllerDelegate?
    var request: Request?
    var object: RequestCollectionViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        itemImage.image = object.itemImage.image
        titleLabel.text = request?.itemTitle
        pickupLoc.text = request?.pickupLocation.location
        dropoffLoc.text = request?.deliverLocation
        priceLabel.text = String(format: "%.2f", (request?.itemCost)!)
        descripLabel.text = request?.itemDescription
        contactLabel.text = "need Contact model"
        
        
    }
    
    // MARK: Helper Methods
    
    func acceptRequest() {
        let currentUser = User.currentUser()
        request?.assignedUser = currentUser
        request?.isAccepted = true
        request?.saveInBackgroundWithBlock{ succeed, error in
            self.delegate?.didAcceptRequest()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

    // MARK: Actions

    @IBAction func acceptButton(sender: UIButton) {
        acceptRequest()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCreatorProfile" {
//            let navController = segue.destinationViewController as! UINavigationController
            let profileVC = segue.destinationViewController as! ProfileTableViewController
            profileVC.currentUser = request?.creatorUser
//            navController.viewControllers = []
//            creatorVC.request = request
        } else if segue.identifier == "MapView" {
            
            let mapViewVC = segue.destinationViewController as! DetailMapViewController
            mapViewVC.request = request
        }
        
        
    }
}
