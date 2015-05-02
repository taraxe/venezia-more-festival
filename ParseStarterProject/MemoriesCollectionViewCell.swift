//
//  MemoriesCollectionViewCell.swift
//  More Venezia
//
//  Created by antoine labbe on 27/04/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Haneke

class MemoriesCollectionViewCell: UICollectionViewCell {
    
    let cache = Shared.imageCache
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var picture:Picture? {
        didSet {
            updateUI()
        }
    }
    
    
    func updateUI() {
        //reset
        self.spinner?.startAnimating()
        self.pictureImageView?.image = nil
            
        if let pic = picture {
                
            let imageURL = WeServ.proxy(pic.small)
            if let url = NSURL(string: imageURL) {
                let fetcher = NetworkFetcher<UIImage>(URL: url)
                //self.artistImageView.hnk_setImageFromURL(wrapped)
                cache.fetch(fetcher: fetcher).onSuccess { image in
                    
                    self.spinner?.stopAnimating
                    
                    UIView.transitionWithView(self.pictureImageView,
                        duration:0.3,
                        options: UIViewAnimationOptions.TransitionCrossDissolve,
                        animations: { self.pictureImageView.image = image },
                        completion: nil
                    )
                }
                
            } else {
                println("CANNOT CREATE URL : \(imageURL)")
            }
        }
    }
    
    override func prepareForReuse() {
        self.pictureImageView?.hnk_cancelSetImage()
        self.pictureImageView?.image = nil
    }

    
}
