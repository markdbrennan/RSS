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
        
        // Add icon to nav item title bar
        let titleIcon:UIImageView = UIImageView(frame: CGRectMake(0, 0, 41, 33))
        titleIcon.image = UIImage(named: "vergeicon")
        self.navigationItem.titleView = titleIcon
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
        let currentArticleToDisplay:Article = self.articles[indexPath.row]
        
        // Set properties
        if let actualLabel = label {
            actualLabel.text = currentArticleToDisplay.articleTitle
        }
        
        if let actualImageView = imageView {
            
            // Imageview exists
            if currentArticleToDisplay.articleImageUrl != "" {
                
                // Create an NSURL object
                let url:NSURL? = NSURL(string: currentArticleToDisplay.articleImageUrl)
                
                // Create an NSURL request
                let imageRequest:NSURLRequest = NSURLRequest(URL: url!)
                
                // Create an NSURLSession
                let session:NSURLSession = NSURLSession.sharedSession()
                
                // Create an NSURLSessionDataTask
                let dataTask:NSURLSessionDataTask = session.dataTaskWithRequest(imageRequest, completionHandler: { (data, response, error) in
                    
                    // Fire off that code to execute on the main thread
                    dispatch_async(dispatch_get_main_queue(), {
                        // When image downloaded, use data to create a UIImage object and assign it to the imageView
                        actualImageView.image = UIImage(data: data!)
                    })
                    
                })
                
                dataTask.resume()
                
            }
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

