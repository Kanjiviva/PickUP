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
    
    
}
