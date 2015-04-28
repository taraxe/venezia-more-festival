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
    
    init(artist:Artist, place:Place, start:NSDate, end:NSDate) {
        self.artist = artist
        self.place = place
        self.start = start
        self.end = end
    }
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
    
    init(name:String, location:(Float, Float), address:String) {
        self.location = location
        self.name = name
        self.address = address
    }
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

class WeServ {
    
    static func proxy(image:Image) -> String {
        return proxy(image.source, height: image.height, width : image.width)
    }
    
    static func proxy(url:String, height:Int? = nil, width:Int? = nil) -> String {
        var encodedURL = url.replace("^https?:\\/\\/(.*)$", template : "$1").encodeURL()
        var out = "http://images.weserv.nl/?url=\(encodedURL)"
        if let h = height {
            out += "&h=\(h)"
        }
        if let w = width {
            out += "&w=\(w)"
        }
        println(out)
        return out
    }
    
}