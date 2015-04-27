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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Slot"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 50
        //self.tableView.estimatedRowHeight = 97
    }
    
    override func queryForTable() -> PFQuery {
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
//        tableView.rowHeight = 75 + 16
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("SlotCell", forIndexPath: indexPath) as! SlotTableViewCell
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
    
    override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject? {
        if let sectionSlots = slots[dateForSection(indexPath.section)] {
            return sectionSlots[indexPath.row]
        } else {
         return nil
        }
    }
    
    override func objectsDidLoad(error: NSError!) {
        super.objectsDidLoad(error)
        if let os = objects {
            println( "\(os.count) received from Parse" )
            
            let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            slots.removeAll(keepCapacity: false)
            
            // let fill the dictionary of days -> slots
            for object in os {
                let slot = object as! PFObject
                let slotDate = object["start"] as! NSDate
                let day = cal.startOfDayForDate(slotDate)
                
                if let prev = slots[day] { slots[day] = prev + [slot] }
                else { slots[day] = [slot] }
            }
            println( "\(slots.count) after filtering" )
            tableView.reloadData()

        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCellTableViewCell
        let formatter = NSDateFormatter()
        formatter.locale = Constants.appLocale
        formatter.dateFormat = "EEE, d MMM"
        let sectionDate = dateForSection(section)
        println("For section \(section), date is \(sectionDate)")
        headerCell.headerLabel.text = formatter.stringFromDate(sectionDate);
        headerCell.headerLabel.textColor = UIColor.whiteColor()
        headerCell.backgroundColor = UIColor.blackColor()
        return headerCell
    }

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
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
                let cell = sender as! SlotTableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    if let artistViewController = destination as? ArtistViewController {
                        artistViewController.object = cell.object
                    }
                }
            default:
                break
            }
        }
    }
}
public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }