//
//  SlotTableViewCell.swift
//  ParseStarterProject
//
//  Created by antoine labbe on 06/03/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class SlotTableViewCell: PFTableViewCell {

    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistImageView: PFImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var object :PFObject? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
        // reset UI 
        artistNameLabel?.attributedText = nil
        timeLabel?.attributedText = nil
        artistImageView?.image = nil
        
        if let slot = self.object {
            
            let artist = slot["artist_id"] as PFObject
            // load image
            if let url = NSURL(string : artist["image"] as String) {
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                    dispatch_async(dispatch_get_global_queue(qos, 0)){ _ in
                        if url == NSURL(string : artist["image"] as String) {
                            if let imageData =  NSData(contentsOfURL: url) {
                                self.artistImageView.image = UIImage(data : imageData)
                                self.artistImageView.loadInBackground()
                            }
            
                        }
            
                    }
            }
        
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            timeLabel?.text = formatter.stringFromDate(slot["start"] as NSDate)
            
    
            artistNameLabel?.text = artist["name"] as? String
        }
        

        
    }

}
