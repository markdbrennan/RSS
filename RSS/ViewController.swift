//
//  ViewController.swift
//  RSS
//
//  Created by Mark Brennan on 27/03/2016.
//  Copyright © 2016 Mark Brennan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FeedModelDelegate {
    
    let feedModel:FeedModel = FeedModel()
    var articles:[Article] = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set itself as the FeedModel delegate
        self.feedModel.delegate = self
        
        // Fire off request to download articles in the background
        self.feedModel.getArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This method is called when a segue occurs
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    // FeedModel delegate methods
    func articlesReady() {
        // FeedModel has notified the view controller that articles are ready
        self.articles = self.feedModel.articles
        
        // TODO: Display articles in tableview
    }


}

