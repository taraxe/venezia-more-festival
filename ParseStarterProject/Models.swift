//
//  Slot.swift
//  TableViewTest
//
//  Created by antoine labbe on 05/03/15.
//  Copyright (c) 2015 Taraxe. All rights reserved.
//

import Foundation
import Parse

struct Slot {
    let start:NSDate
    let end:NSDate
    let artist:Artist
    let place:Place
}

struct Artist {
    let name :String
    let picture:NSURL
    let soundCloud:NSURL
    
    init(name:String, picture:NSURL, soundCloud:NSURL) {
        self.name = name
        self.picture = picture
        self.soundCloud = soundCloud
    }
}

struct Place {
    let location:(Float, Float)
    let name:String
    let address:String
}

struct Picture {
    let big:Image
    let small:Image
    let caption:String?
    
    init(dic:Dictionary<String, AnyObject>) {
        self.big = Image(dic : dic["big"] as! Dictionary<String, AnyObject>)
        self.small = Image(dic : dic["small"] as! Dictionary<String, AnyObject>)
        self.caption = dic["name"] as? String
    }
}

struct Image {
    let width:Int
    let height:Int
    let source:String
    
    init(dic:Dictionary<String, AnyObject>) {
        self.source = dic["source"] as! String
        self.width = dic["width"] as! Int
        self.height = dic["height"] as! Int
    }
}

enum InfoProtocol:String {
    case Tel = "tel"
    case Sms = "sms"
    case Http = "http"
    case Https = "https"
    case Email = "mailto"
    case Facebook = "fb"
    case Twitter = "twitter"
}

struct InfoSection {
    let name:String
    let order:Int
    let items:[InfoItem]
    init(dic:Dictionary<String, AnyObject>) {
        self.name = dic["name"] as! String
        let items = dic["items"] as! [Dictionary<String, AnyObject>]
        self.items = items.map({i in InfoItem(dic: i)})
        self.order = dic["order"] as! Int
    }
    
}

struct InfoItem {
    let name:String
    let proto:InfoProtocol?
    let value:String
    let path:String?
    
    init(dic:Dictionary<String, AnyObject>) {
        self.name = dic["name"] as! String
        self.value = dic["value"] as! String
        self.path = dic["path"] as? String
        if let p = dic["protocol"] as? String {
            self.proto = InfoProtocol(rawValue: p)
        } else {
            self.proto = nil
        }
    }
}



class WeServ {
    
    static func proxy(image:Image) -> String {
        return proxy(image.source, height: image.height, width : image.width)
    }
    
    static func proxy(url:String, height:Int? = nil, width:Int? = nil) -> String {
        let encodedURL = url.replace("^https?:\\/\\/(.*)$", template : "$1").encodeURL()
        var out = "http://images.weserv.nl/?url=\(encodedURL)"
        if let h = height {
            out += "&h=\(h)"
        }
        if let w = width {
            out += "&w=\(w)"
        }
        print(out)
        return out
    }
    
}