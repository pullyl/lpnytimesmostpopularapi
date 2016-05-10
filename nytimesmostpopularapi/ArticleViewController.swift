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
        
        //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        //self.presentingViewController.dismiss
        
        //set text on screen
        let label = UILabel(frame: CGRectMake(0, 100, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        //label.text = details["title"]
        label.text = "hello second world"
        self.view.addSubview(label)
    
        print("ArticleViewController - end viewDidLoad")
    }
}
