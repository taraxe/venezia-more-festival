//
//  ArtistViewController.swift
//  More Venezia
//
//  Created by antoine labbe on 07/03/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class ArtistViewController: UIViewController {

    var object :PFObject? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var artistImage: PFImageView!
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UIButton!
    
    func updateUI(){
        bioLabel?.attributedText = nil
        dateLabel?.attributedText = nil
        
        if let slot = self.object {
            let artist = slot["artist_id"] as PFObject
            let name = artist["name"] as String
            let bio = artist["bio"] as String
            let (start, end) = (slot["start"] as NSDate, slot["end"] as NSDate)
            
            
            title = name
            bioLabel?.text = bio
            
            
            
            // load image
            if let url = NSURL(string : artist["image"] as String) {
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)){ _ in
                    if url == NSURL(string : artist["image"] as String) {
                        if let imageData =  NSData(contentsOfURL: url) {
                            self.artistImage.image = UIImage(data : imageData)
                            self.artistImage.loadInBackground()
                        }
                        
                    }
                    
                }
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm"
            dateLabel?.text = "\(formatter.stringFromDate(start)) - \(formatter.stringFromDate(end))"


        }
    }
    
    override func viewDidLoad() {
        
        updateUI()
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
