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
        @IBOutlet weak var soundcloudButton: UIButton!
        
        @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
        
        @IBAction func shareAction(sender: UIBarButtonItem) {
            
            
            if let slot = self.object {
                let artist = slot["artist_id"] as! PFObject
                let name = artist["name"] as! String
                
                let text:String = "Come to see \(name) at More Festival Venezia"
                let url:NSURL = NSURL(string: "http://www.more-festival.com/")!
                let image:UIImage = artistImage.image!
                
                let activityViewController = UIActivityViewController(activityItems: [text, image, url], applicationActivities: nil)
                self.presentViewController(activityViewController, animated: true, completion: nil)
            }
        }
        
        @IBAction func showPlace() {
            if let slot = self.object {
                let stage = slot["stage_id"] as! PFObject
                let (lat, long) = (stage["lat"] as! NSNumber, stage["long"] as! NSNumber)
                
                let gMapsURL = NSURL(string:"comgooglemaps-x-callback://?q=\(lat),\(long)&x-success=morefest://?resume=true&x-source=More+Festival")
                let dMapURL = NSURL(string: "http://maps.apple.com/?q=\(lat),\(long)&z=100")
                
                if (UIApplication.sharedApplication().canOpenURL(gMapsURL!)) {
                    print(gMapsURL)
                    UIApplication.sharedApplication().openURL(gMapsURL!)
                } else {
                    print(dMapURL)
                    UIApplication.sharedApplication().openURL(dMapURL!)
                }
                
            }
            
        }
        
        func updateUI(){
            if let b = tabBarController?.tabBar.bounds {
                print(b)
                bottomConstraint?.constant = b.height + 20
            }
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
                    
                    let imageURL = WeServ.proxy((artist["image"] as! String), height: 1200, width: 492)
                    
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
                        print("CANNOT CREATE URL : \(imageURL)")
                    }
                }
                
                let formatter = NSDateFormatter()
                formatter.locale = Constants.appLocale
                formatter.dateFormat = "hh:mm a"
                
                
                dateLabel?.text = "\(formatter.stringFromDate(start)) - \(formatter.stringFromDate(end))"
                
                let soundcloud = artist["soundcloud"] as? String
                if soundcloud == nil {
                    print("Will hide button \(soundcloud)")
                    self.soundcloudButton?.hidden = true
                }
            }
            
        }
        
        @IBAction func openSoundcloud(sender: AnyObject) {
            if let slot = self.object {
                if let artist = slot["artist_id"] as? PFObject {
                    if let soundcloud = artist["soundcloud"] as? String {
                        if let url = NSURL(string: soundcloud) {
                            if (UIApplication.sharedApplication().canOpenURL(url)) {
                                UIApplication.sharedApplication().openURL(url)
                            }
                        }
                    }
                }
            }
        }
        
        override func viewDidLoad() {
            updateUI()
        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
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
