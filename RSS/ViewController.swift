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
    var selectedArticle:Article?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set delegates of tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        // Set itself as the FeedModel delegate
        self.feedModel.delegate = self
        
        // Fire off request to download articles in the background
        self.feedModel.getArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        // Grab the elements using the tag
        let label:UILabel? = cell.viewWithTag(1) as! UILabel?
        let imageView:UIImageView? = cell.viewWithTag(2) as! UIImageView?
        
        // Set properties
        if let actualLabel = label {
            let currentArticleToDisplay:Article = self.articles[indexPath.row]
            actualLabel.text = currentArticleToDisplay.articleTitle
        }
        
        // Set insets to zero
        cell.layoutMargins = UIEdgeInsetsZero
        
        // Return the cell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // User selected a row
        
        // Keep track of which article the user selected
        self.selectedArticle = self.articles[indexPath.row]
        
        // Trigger segue to detail view
        self.performSegueWithIdentifier("toDetailSegue", sender: self)
    }
    
    // This method is called when a segue occurs
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get reference to destination view controller
        let detailVC = segue.destinationViewController as! DetailViewController
        detailVC.articleToDisplay = self.selectedArticle
        
        // Pass along the selected article
        
    }


}

