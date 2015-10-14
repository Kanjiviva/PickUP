//
//  TabBarController.swift
//  PickUP
//
//  Created by Derrick Park on 2015-10-14.
//  Copyright © 2015 Steve. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor.init(netHex: 0xE54B4B)
        self.tabBar.barTintColor = UIColor.init(netHex: 0x16528E)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
