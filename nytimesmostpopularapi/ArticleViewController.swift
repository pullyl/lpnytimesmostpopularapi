//
//  ArticleViewController.swift
//  nytimesmostpopularapi
//
//  Created by Lauren Pully on 5/9/16.
//  Copyright © 2016 laurenpully. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    var details: NYTimesApiEntity!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ArticleViewController - viewDidLoad")
        
        print("testing nav controller in ArticleViewController")
        print(self.navigationController)
        
        let webView:UIWebView = UIWebView(frame: CGRectMake(15, 50, UIScreen.mainScreen().bounds.width - 20, UIScreen.mainScreen().bounds.height))
        
        var html = "<img src=\"" + details.image_url! + "\">" + "<br><br><h1>"
        html = html + details.title! + "</h1><br>" + details.published_date!
        
        webView.loadHTMLString(html, baseURL: nil)
        self.view.addSubview(webView)
        
        //Add back button
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(5, 20, 100, 20)
        button.setTitle("Back", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(ArticleViewController.buttonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
                
        print("ArticleViewController - end viewDidLoad")
    }
    
    func buttonPressed(sender:UIButton!)
    {
        print("ArticleViewController - buttonPressed")
        //self.navigationController.popViewControllerAnimated(true)
        
        print(self.navigationController)
        
        if let navController = self.navigationController {
            print("here")
            //navController.popViewControllerAnimated(true)
            navController.popToRootViewControllerAnimated(true)

        }


    }
}
