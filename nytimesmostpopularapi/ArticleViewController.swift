//
//  ArticleViewController.swift
//  nytimesmostpopularapi
//
//  Created by Lauren Pully on 5/9/16.
//  Copyright © 2016 laurenpully. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    var details: [String: String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ArticleViewController - viewDidLoad")
        
        let webView:UIWebView = UIWebView(frame: CGRectMake(15, 50, UIScreen.mainScreen().bounds.width - 20, UIScreen.mainScreen().bounds.height))
        let html = "<img src=\"" + details["image_url"]! + "\">" + "<br><br><h1>" + details["title"]! + "</h1><br>" + details["publish_date"]!
        webView.loadHTMLString(html, baseURL: nil)
        self.view.addSubview(webView)
                
        print("ArticleViewController - end viewDidLoad")
    }
}
