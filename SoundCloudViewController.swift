//
//  SoundCloudViewController.swift
//  ParseStarterProject
//
//  Created by antoine labbe on 06/03/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SoundCloudViewController: UIViewController {


    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        PFConfig.getConfigInBackgroundWithBlock {
            (var config: PFConfig?, error: NSError?) -> Void in
            if error == nil {
                println("Yay! Config was fetched from the server.")
            } else {
                println("Failed to fetch. Using Cached Config.")
                config = PFConfig.currentConfig()
            }
            
            var url = config?["playlist_soundcloud_url"] as? String

            let webURL = NSURL(string: "https://w.soundcloud.com/player/?url=\(url!.encodeURL())&amp;hide_related=true&amp;show_comments=false&amp;show_reposts=false&amp;visual=true")
            let urlRequest = NSURLRequest(URL: webURL!)
            self.webView.loadRequest(urlRequest)
        };
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
