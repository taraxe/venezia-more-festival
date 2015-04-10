//
//  SlotsUISplitViewController.swift
//  More Venezia
//
//  Created by antoine labbe on 10/04/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class SlotsUISplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {

        println("HIT")
        
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? ArtistViewController {
                if topAsDetailController.object == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }
   
}
