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
import Haneke

class SlotTableViewCell: PFTableViewCell {
    
    let cache = Shared.imageCache
    
    @IBOutlet weak var artistImageView: UIImageView!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
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
            
            let artist = slot["artist_id"] as! PFObject
            // load image
            let imageURL = WeServ.proxy((artist["image"] as! String), height: 150, width: 150)
            
            if let url = NSURL(string: imageURL) {
                let fetcher = NetworkFetcher<UIImage>(URL: url)
                //self.artistImageView.hnk_setImageFromURL(wrapped)
                cache.fetch(fetcher: fetcher).onSuccess { image in
                    UIView.transitionWithView(self.artistImageView,
                        duration:0.3,
                        options: UIViewAnimationOptions.TransitionCrossDissolve,
                        animations: { self.artistImageView.image = image },
                        completion: nil
                    )
                }
                
            } else {
                print("CANNOT CREATE URL : \(imageURL)")
            }
            
            
            let formatter = NSDateFormatter()
            formatter.locale = Constants.appLocale
            formatter.dateFormat = "hh:mm a"
            let (start, end) = (slot["start"] as! NSDate , slot["end"] as! NSDate)
            
            timeLabel?.text = "\(formatter.stringFromDate(start)) - \(formatter.stringFromDate(end))"
            
            
            artistNameLabel?.text = artist["name"] as? String
        }
        
        
    }
    
    override func prepareForReuse() {
        artistImageView.hnk_cancelSetImage()
        artistImageView.image = nil
        artistNameLabel.text = nil
        timeLabel.text = nil
    }
}
