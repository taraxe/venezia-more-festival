//
//  ArtistViewController.swift
//  More Venezia
//
//  Created by antoine labbe on 07/03/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ArtistViewController: UIViewController {

    var object :PFObject? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI(){
        
        
        if let slot = self.object {
            
            let artist = slot["artist_id"] as PFObject
            println(artist["name"] as String)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
