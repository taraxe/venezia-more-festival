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

extension String {
    func toDate(let format:String = "dd/MM/yyyy hh:mm") -> NSDate? {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone()
        formatter.dateFormat = format
        
        return formatter.dateFromString(self)
    }
}