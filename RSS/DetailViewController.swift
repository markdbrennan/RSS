//
//  DetailViewController.swift
//  RSS
//
//  Created by Mark Brennan on 27/03/2016.
//  Copyright © 2016 Mark Brennan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var articleToDisplay:Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add icon to nav item title bar
        let titleIcon:UIImageView = UIImageView(frame: CGRectMake(0, 0, 41, 33))
        titleIcon.image = UIImage(named: "vergeicon")
        self.navigationItem.titleView = titleIcon
        
        // Check if theres an article to display
        if let actualArticle = self.articleToDisplay {
            
            // Create NSURL for the article URL
            let url:NSURL? = NSURL(string: actualArticle.articleLink)
            
            // Check if an NSURL object was created
            if let actualUrl = url {
                // Create NSURLRequest for the NSURL
                let urlRequest:NSURLRequest = NSURLRequest(URL: actualUrl)
                
                self.webView.loadRequest(urlRequest)
            }
            
            
            // Pass the request into the webview to load page
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
