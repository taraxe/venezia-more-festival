//
//  Utils.swift
//  More Venezia
//
//  Created by antoine labbe on 21/04/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

struct Regex {
    var pattern: String {
        didSet {
            updateRegex()
        }
    }
    var expressionOptions: NSRegularExpressionOptions {
        didSet {
            updateRegex()
        }
    }
    var matchingOptions: NSMatchingOptions
    
    var regex: NSRegularExpression?
    
    init(pattern: String, expressionOptions: NSRegularExpressionOptions, matchingOptions: NSMatchingOptions) {
        self.pattern = pattern
        self.expressionOptions = expressionOptions
        self.matchingOptions = matchingOptions
        updateRegex()
    }
    
    init(pattern: String) {
        self.pattern = pattern
        expressionOptions = NSRegularExpressionOptions(0)
        matchingOptions = NSMatchingOptions(0)
        updateRegex()
    }
    
    mutating func updateRegex() {
        regex = NSRegularExpression(pattern: pattern, options: expressionOptions, error: nil)
    }
}


extension String {
    func matchRegex(pattern: Regex) -> Bool {
        let range: NSRange = NSMakeRange(0, count(self))
        if pattern.regex != nil {
            let matches: [AnyObject] = pattern.regex!.matchesInString(self, options: pattern.matchingOptions, range: range)
            return matches.count > 0
        }
        return false
    }
    
    func match(patternString: String) -> Bool {
        return self.matchRegex(Regex(pattern: patternString))
    }
    
    func replaceRegex(pattern: Regex, template: String) -> String {
        if self.matchRegex(pattern) {
            let range: NSRange = NSMakeRange(0, count(self))
            if pattern.regex != nil {
                return pattern.regex!.stringByReplacingMatchesInString(self, options: pattern.matchingOptions, range: range, withTemplate: template)
            }
        }
        return self
    }
    
    func replace(pattern: String, template: String) -> String {
        return self.replaceRegex(Regex(pattern: pattern), template: template)
    }
    
    public func encodeURL() -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":/?&=;+!@#$()',*"
        
        return CFURLCreateStringByAddingPercentEscapes(nil, self,
            nil, legalURLCharactersToBeEscaped,
            CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}

extension Optional {
    func or(defaultValue: T) -> T {
        switch(self) {
        case .None:
            return defaultValue
        case .Some(let value):
            return value
        }
    }
}
