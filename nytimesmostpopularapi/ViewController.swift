//
//  ViewController.swift
//  nytimesmostpopularapi
//
//  Created by Lauren Pully on 5/9/16.
//  Copyright © 2016 laurenpully. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var objects = [[String: String]]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print ("viewDidLoad")
    
        //set text on screen
        let label = UILabel(frame: CGRectMake(0, 100, 200, 21))
        label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "hello world"
        self.view.addSubview(label)
        
        print("end viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//end

