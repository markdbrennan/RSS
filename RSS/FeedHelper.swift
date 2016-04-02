//
//  FeedHelper.swift
//  RSS
//
//  Created by Mark Brennan on 27/03/2016.
//  Copyright © 2016 Mark Brennan. All rights reserved.
//

import UIKit

class FeedHelper: NSObject, NSXMLParserDelegate {
    
    var articles:[Article] = [Article]()
    
    // Parser variables
    var currentElement:String = ""
    var foundCharacters:String = ""
    var attributes:[NSObject:AnyObject]?
    var currentlyConstructingArticle:Article = Article()
    
    func startParsing(feedUrl:NSURL) {
        let feedParser:NSXMLParser? = NSXMLParser(contentsOfURL: feedUrl)
        if let actualFeedParser = feedParser {
            // Download feed and parse articles
            actualFeedParser.delegate = self
            actualFeedParser.parse()
        }
    }
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "entry" ||
            elementName == "title" ||
            elementName == "content" ||
            elementName == "link" {
            
            self.currentElement = elementName
            self.attributes = attributeDict
            
            if elementName == "entry" {
                // Start new article
                self.currentlyConstructingArticle = Article()
            }
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if self.currentElement == "entry" ||
            self.currentElement == "title" ||
            self.currentElement == "content" ||
            self.currentElement == "link" {
            
            // Append found characters to variable
            self.foundCharacters += string
        }
    }
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "title" {
            
            // Parsing of the title element is complete, save the data
            let title:String = foundCharacters.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            self.currentlyConstructingArticle.articleTitle = title
            
        } else if elementName == "content" {
            
            // Extract article image from the content and save it to the articleImageUrl property of the article object
            
            // Search for 'http'
            if let startRange = foundCharacters.rangeOfString("http", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                
                // Search for '.jpg'
                if let endRange = foundCharacters.rangeOfString(".jpg", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                    
                    // Take the substring out for start range to end range
                    let imgString:String = foundCharacters.substringWithRange(Range<String.Index>(start: startRange.startIndex, end: endRange.endIndex))
                    
                    self.currentlyConstructingArticle.articleImageUrl = imgString
                    
                    // If '.jpg' is not found, search for '.png'
                } else if let endRange = foundCharacters.rangeOfString(".png", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                    
                    // Take the substring out for start range to end range
                    let imgString:String = foundCharacters.substringWithRange(Range<String.Index>(start: startRange.startIndex, end: endRange.endIndex))
                    
                    self.currentlyConstructingArticle.articleImageUrl = imgString
                    
                }
            }
            
            self.currentlyConstructingArticle.articleDescription = foundCharacters
            
        } else if elementName == "link" {
            
            // Get the href key value pair out of the attributes dictionary
            self.currentlyConstructingArticle.articleLink = self.attributes!["href"] as! String
            
        } else if elementName == "entry" {
            
            // Parsing of a story entry is complete, append the object to the article array
            self.articles.append(self.currentlyConstructingArticle)
   
        }
        
        // Reset found characters
        self.foundCharacters = ""
        
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        // Use notification center to notify feedModel
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("feedHelperFinished", object: self)
    }
}