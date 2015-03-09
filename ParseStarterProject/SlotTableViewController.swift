//
//  SlotsViewController.swift
//  ParseStarterProject
//
//  Created by antoine labbe on 06/03/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SlotTableViewController: PFQueryTableViewController {
    
    //var slots = [[Slot]]()
    
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Slot"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 50
        //self.tableView.estimatedRowHeight = 82
    }
    
    override func queryForTable() -> PFQuery! {
        var slotQuery = PFQuery(className:"Slot")
        slotQuery.includeKey("artist_id")
        slotQuery.includeKey("stage_id")
        //slotQuery.fromLocalDatastore()
        slotQuery.orderByAscending("start")
        return slotQuery
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view, typically from a nib.
        //tableView.estimatedRowHeight = tableView.rowHeight
        //tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("SlotCell", forIndexPath: indexPath) as SlotTableViewCell
        cell.object = object
        return cell
    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        //TODO
//    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Date \(section)"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("HIT")
//        var destination = segue.destinationViewController as? UIViewController
//        if let navCon = segue.destinationViewController as? UINavigationController {
//            destination = navCon.visibleViewController
//        }
//        
//        switch (segue.identifier, segue.destinationViewController) {
//        case let (i, d as ArtistViewController) where i == "ShowArtist":
//            if let cell = (sender as? SlotTableViewCell) {
//                d.object = cell.object
//            }
//            //            d.itemForDetail = item
//        default:
//            break;
//        }
        
    }
}
