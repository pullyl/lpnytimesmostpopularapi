//
//  ViewController.swift
//  nytimesmostpopularapi
//
//  Created by Lauren Pully on 5/9/16.
//  Copyright © 2016 laurenpully. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var objects = [[String: String]]()

    
    func parseJSON(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let byline = result["byline"].stringValue
            let obj = ["title": title, "byline": byline]
            objects.append(obj)
        }
        
        print("done parsing json")
        
        //tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print ("viewDidLoad")
        
        //read in API
        let apiURLString = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=98fa23b7d5b542f2be105b8384512928"
        
        print ("viewDidLoad set apiURLString to: ", apiURLString)
        
        if let url = NSURL(string: apiURLString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                
                if json["status"] == "OK" {
                    parseJSON(json)
                }
                
                else{
                    print("error parsing JSON")
                }
            }
        }
    
    
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

