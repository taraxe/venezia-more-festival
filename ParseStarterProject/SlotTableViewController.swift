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
    
    var slots = [NSDate : [PFObject]]()
    
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Slot"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 50
        //self.tableView.estimatedRowHeight = 97
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
        tableView.rowHeight = 75 + 16
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("SlotCell", forIndexPath: indexPath) as SlotTableViewCell
        cell.object = object
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slots[dateForSection(section)]?.count ?? 0
    }
    
    private func dateForSection(section:Int) -> NSDate {
        let dates:[NSDate] = Array(slots.keys).sorted({ $0 < $1 })
        return dates[section]
    }
    
    override func objectsDidLoad(error: NSError!) {
        super.objectsDidLoad(error)
        
        println( "\(objects.count) received from Parse" )

        let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        slots.removeAll(keepCapacity: false)
        
        // let fill the dictionary of days -> slots
        for object in objects {
            let slot = object as PFObject
            let slotDate = object["start"] as NSDate
            let day = cal.startOfDayForDate(slotDate)

            if let prev = slots[day] { slots[day] = prev + [slot] }
            else { slots[day] = [slot] }
        }
        println( "\(slots.count) after filtering" )
        tableView.reloadData()
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "dd/MM"
//        let sectionDate = dateForSection(section)
//        println("For section \(section), date is \(sectionDate)")
//        return formatter.stringFromDate(sectionDate)
//    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as CustomHeaderCellTableViewCell
        headerCell.backgroundColor = UIColor.cyanColor()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM"
        let sectionDate = dateForSection(section)
        println("For section \(section), date is \(sectionDate)")
        headerCell.headerLabel.text = formatter.stringFromDate(sectionDate);
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return slots.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
        if let identifier = segue.identifier {
            switch identifier {
            case "ShowArtist":
                let cell = sender as SlotTableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    if let artistViewController = destination as? ArtistViewController {
                        artistViewController.object = cell.object
                    }
                }
            default:
                break
            }
        }
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
public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }