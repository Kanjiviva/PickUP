//
//  RequestCollectionViewCell.swift
//  PickUP
//
//  Created by Derrick Park on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

import UIKit
import Parse
import Bolts

class RequestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemCost: UILabel!
    @IBOutlet weak var distanceFromCurrentUserLabel: UILabel!
    
    var object: Request! {
        didSet {
            itemTitle.text = object.itemTitle
            itemCost.text = String(format: "%.2f", object.itemCost)
            distanceFromCurrentUserLabel.text = String(format: "%.1f Km", object.distanceFromPickupLoc / 1000)
            let tempObject = object
            
            if (object.itemImage != oldValue?.itemImage) {
                itemImage.image = UIImage(named: "defaultPhoto")
                if let itemPhoto = object.itemImage {
                    itemPhoto.getDataInBackgroundWithBlock { data, error in
                        if (self.object == tempObject) {
                            if let newData = data {
                                self.itemImage.image = UIImage(data: newData)
                            }
                        }
                        
                    }
                }
            }
        }
    }
}
