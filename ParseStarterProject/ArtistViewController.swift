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
import Haneke

class ArtistViewController: UIViewController {

    let cache = Shared.imageCache
    

    
    var object :PFObject? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var artistImage: UIImageView!
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UIButton!
    
    
    @IBAction func showPlace() {
        if let slot = self.object {
            let stage = slot["stage_id"] as! PFObject
            let (lat, long) = (stage["lat"] as! NSNumber, stage["long"] as! NSNumber)
            let stageName = stage["name"] as! String
            
            let gMapsURL = NSURL(string:"comgooglemaps-x-callback://?q=\(lat),\(long)&x-success=morefest://?resume=true&x-source=More+Festival")
            let dMapURL = NSURL(string: "http://maps.apple.com/?q=\(lat),\(long)&z=100")
            
            if (UIApplication.sharedApplication().canOpenURL(gMapsURL!)) {
                println(gMapsURL)
                UIApplication.sharedApplication().openURL(gMapsURL!)
            } else {
                println(dMapURL)
                UIApplication.sharedApplication().openURL(dMapURL!)
            }
            
        }
        
    }
    
    func updateUI(){
        bioLabel?.attributedText = nil
        dateLabel?.attributedText = nil
        
        if let slot = self.object {
            let artist = slot["artist_id"] as! PFObject
            let stage = slot["stage_id"] as! PFObject
            
            let name = artist["name"] as! String
            let bio = artist["bio"]as! String
            let (start, end) = (slot["start"] as! NSDate, slot["end"] as! NSDate)
            

            title = name
            bioLabel?.text = bio
            
            if let placeBt = self.placeLabel {
                let stageName = stage["name"] as! String
                placeBt.setTitle(stageName, forState: .Normal)
            }
            
            
            
            if let artistImg = self.artistImage {
                
                let imageURL = WeServ.proxy((artist["image"] as! String), height: 300)
                
                if let url = NSURL(string: imageURL) {
                    let fetcher = NetworkFetcher<UIImage>(URL: url)
                    cache.fetch(fetcher: fetcher).onSuccess { image in
                        UIView.transitionWithView(artistImg,
                            duration:0.3,
                            options: UIViewAnimationOptions.TransitionCrossDissolve,
                            animations: { self.artistImage.image = image },
                            completion: nil
                        )
                    }
                    
                } else {
                    println("CANNOT CREATE URL : \(imageURL)")
                }
            }

            let formatter = NSDateFormatter()
            formatter.locale = Constants.appLocale
            formatter.dateFormat = "hh:mm a"
        
            
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
