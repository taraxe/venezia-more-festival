//
//  MemoriesCollectionViewController.swift
//  More Venezia
//
//  Created by antoine labbe on 27/03/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

let reuseIdentifier = "MemoryCell"

class MemoriesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var pictures = [Picture]()
    var refreshControl:UIRefreshControl?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.registerClass(MemoriesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
        collectionView?.addSubview(refreshControl!)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView!.delegate = self
        
        loadData()
    }
    
    func loadData() {
        PFCloud.callFunctionInBackground("images", withParameters:[:]) { (result: AnyObject?, error: NSError?) -> Void in
            if error == nil {
                let images = result! as! Array<Dictionary<String, AnyObject>>
                
                self.pictures.removeAll(keepCapacity: false)
                
                self.pictures += images.map({ i in Picture(dic : i)})
                
                println("Received \(self.pictures.count) pictures")
                
                self.collectionView?.reloadData()
                
            } else {
                println(error)
            }
        }
        self.refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return pictures.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemoriesCollectionViewCell

        cell.picture = pictures[indexPath.row]
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = (self.view.frame.size.width / 3.0)
        return CGSizeMake(picDimension - 1.0, picDimension)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    // so sizeForItemAtIndexPath gets called
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
        
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowPicture":
                let cell = sender as! MemoriesCollectionViewCell
                if let memoryViewController = destination as? MemoryViewController {
                    memoryViewController.image = cell.picture?.big
                }

 
            default:
                break
            }
        }
        
    }

}
