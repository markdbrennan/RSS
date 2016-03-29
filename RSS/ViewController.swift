//
//  ViewController.swift
//  RSS
//
//  Created by Mark Brennan on 27/03/2016.
//  Copyright © 2016 Mark Brennan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FeedModelDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let feedModel:FeedModel = FeedModel()
    var articles:[Article] = [Article]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set delegates of tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
        
        // Display articles in tableview
        self.tableView.reloadData()
    }
    
    
    // Tableview delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Try to reuse cell
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("BasicCell")!
        
        // Set properties
        let currentArticleToDisplay:Article = self.articles[indexPath.row]
        cell.textLabel?.text = currentArticleToDisplay.articleTitle
        
        // Return the cell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // User selected a row
        
        // Trigger segue to detail view
    }


}

