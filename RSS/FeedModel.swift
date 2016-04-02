//
//  FeedModel.swift
//  RSS
//
//  Created by Mark Brennan on 27/03/2016.
//  Copyright © 2016 Mark Brennan. All rights reserved.
//

import UIKit

protocol FeedModelDelegate {
    
    // Any FeedModelDelegate must implement this method
    // FeedModel will call this method when article array is ready
    func articlesReady()
}

class FeedModel: NSObject {
    
    let feedUrlString:String = "https://www.theverge.com/rss/frontpage"
    var articles:[Article] = [Article]()
    var delegate:FeedModelDelegate?
    var feedHelper:FeedHelper = FeedHelper()

    func getArticles(){
        // Create URL
        let feedUrl:NSURL? = NSURL(string: feedUrlString)
        
        // Listen to notification center
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(FeedModel.parserFinished), name: "feedHelperFinished", object: self.feedHelper)
        
        // Call FeedHelper to parse url
        self.feedHelper.startParsing(feedUrl!)
    }
    
    func parserFinished() {
        // Assign parsers list of articles to self.articles
       self.articles = self.feedHelper.articles

        // If an object is assigned as the delegate, call the articlesReady method on it
        if let actualDelegate = self.delegate {
            actualDelegate.articlesReady()
        }
    }
    
  }
