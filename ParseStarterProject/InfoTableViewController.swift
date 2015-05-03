//
//  InfoTableViewController.swift
//  More Venezia
//
//  Created by antoine labbe on 02/05/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class InfoTableViewController : UITableViewController {
    
    var infos = [InfoSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    
    @IBAction func refreshInfos(sender: UIRefreshControl) {
        loadData()
    }
    
    func loadData(){
        
        PFConfig.getConfigInBackgroundWithBlock {
            (var config: PFConfig?, error: NSError?) -> Void in
            if error == nil {
                println("Yay! Config was fetched from the server.")
            } else {
                println("Failed to fetch. Using Cached Config.")
                config = PFConfig.currentConfig()
            }
            self.refreshControl?.endRefreshing()
            self.infos.removeAll(keepCapacity: false)
            
            if let sections = config?["app_infos"] as? [Dictionary<String, AnyObject>] {
                self.infos += sections.map({s in InfoSection(dic: s)})
                self.infos.sorted({ $0.order < $1.order })
                self.tableView?.reloadData()
            }

        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! UITableViewCell

        let i = infos[indexPath.section].items[indexPath.row]
        cell.detailTextLabel?.text = i.value
        
        switch i.name.lowercaseString {
        case "facebook" :
            cell.imageView?.image = UIImage(named: "facebook")
        case "twitter" :
            cell.imageView?.image = UIImage(named: "twitter")
        case "email" :
            cell.imageView?.image = UIImage(named: "email_circle")
        default:
            cell.textLabel?.text = i.name
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return infos[section].name
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos[section].items.count
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return infos.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let i = infos[indexPath.section].items[indexPath.row]

        if let protoc = i.proto {
            let urlS = "\(protoc.rawValue)://\(i.path.or(i.value))"
            println(urlS)
            if let url = NSURL(string: urlS) {
                let application:UIApplication = UIApplication.sharedApplication()
                if (application.canOpenURL(url)) {
                    application.openURL(url);
                }
            }
            
        }
        
    }
    
}
