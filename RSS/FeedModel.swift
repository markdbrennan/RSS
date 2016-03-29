//
//  FeedModel.swift
//  RSS
//
//  Created by Mark Brennan on 27/03/2016.
//  Copyright © 2016 Mark Brennan. All rights reserved.
//

import UIKit

class FeedModel: NSObject, NSXMLParserDelegate {
    
    let feedUrlString:String = "https://www.theverge.com/rss/frontpage"
    var articles:[Article] = [Article]()
    
    // Parser vars
    var currentElement:String = ""
    var foundCharacters:String = ""
    var attributes:[NSObject:AnyObject]?
    var currentlyConstructingArticle:Article = Article()

    func getArticles(){
        // Initialise a new parser
        let feedUrl:NSURL? = NSURL(string: feedUrlString)
        let feedParser:NSXMLParser? = NSXMLParser(contentsOfURL: feedUrl!)
        
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
            self.currentlyConstructingArticle.articleTitle = foundCharacters
            
            // Reset the found characters variable
            self.foundCharacters = ""
            
        } else if elementName == "content" {
            
            // TODO: Extract article image
            
            self.currentlyConstructingArticle.articleDescription = foundCharacters
            self.foundCharacters = ""
            
        } else if elementName == "link" {
            
            // Get the href key value pair out of the attributes dictionary
            self.currentlyConstructingArticle.articleLink = self.attributes!["href"] as! String
            self.foundCharacters = ""
            
        } else if elementName == "entry" {
            
            // Parsing of a story entry is complete, append the object to the article array
            self.articles.append(self.currentlyConstructingArticle)
            
            // Start new article
            self.currentlyConstructingArticle = Article()
            
            // Reset found characters
            self.foundCharacters = ""
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        // TODO: Notify the view controller that the array of articles is ready
        
    }
}
