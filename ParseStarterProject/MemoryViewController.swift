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
}