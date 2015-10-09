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
    
    var delegate: RequestDetailViewControllerDelegate?
    var request: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        itemTitle.text = request?.itemTitle
        
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
        }
    }
}
