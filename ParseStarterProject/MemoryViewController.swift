//
//  MemoryViewController.swift
//  More Venezia
//
//  Created by antoine labbe on 28/04/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Haneke

class MemoryViewController: UIViewController {
    let cache = Shared.imageCache
    
    @IBOutlet weak var imageView: UIImageView!

    var image:Image? {
        didSet {
            updateUI()
        }
    }
    
    @IBAction func shareAction(sender: UIBarButtonItem) {
        let text:String = "Check out this picture from Venezia More Festival"
        let url:NSURL = NSURL(string: "http://www.more-festival.com/")!
        let image:UIImage = imageView.image!
            
        let activityViewController = UIActivityViewController(activityItems: [text, image, url], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        updateUI()
    }
    
    func updateUI(){
        if let imgView = self.imageView {
            
            if let img = self.image {
                
                let imageURL = WeServ.proxy(img)
                if let url = NSURL(string: imageURL) {
                    let fetcher = NetworkFetcher<UIImage>(URL: url)
                    //self.artistImageView.hnk_setImageFromURL(wrapped)
                    cache.fetch(fetcher: fetcher).onSuccess { image in
                        UIView.transitionWithView(imgView,
                            duration:0.3,
                            options: UIViewAnimationOptions.TransitionCrossDissolve,
                            animations: { imgView.image = image },
                            completion: nil
                        )
                    }
                    
                } else {
                    println("CANNOT CREATE URL : \(imageURL)")
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}