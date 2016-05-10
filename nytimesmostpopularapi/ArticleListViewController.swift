//
//  ArticleListViewController.swift
//  nytimesmostpopularapi
//
//  Created by Lauren Pully on 5/9/16.
//  Copyright © 2016 laurenpully. All rights reserved.
//

import Foundation
import UIKit

class ArticleListViewController: UITableViewController {
    
    var articleViewController: ArticleViewController? = nil
    var objects = [[String: String]]()
    
    func parseJSON(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let byline = result["byline"].stringValue
            let publish_date = result["publish_date"].stringValue
            let obj = ["title": title, "byline": byline, "publich_date": publish_date]
            objects.append(obj)
        }
        
        print("MasterView - done parsing json")
        
        tableView.reloadData()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print ("MasterView - viewDidLoad")
        
        //read in API
        let apiURLString = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=98fa23b7d5b542f2be105b8384512928"
        //let apiURLString = "http://localhost/nytimes/data.json"
        
        print ("MasterView - viewDidLoad set apiURLString to: ", apiURLString)
        
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
        
        print("MasterView - end viewDidLoad")

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("ArticleListViewController - prepareForSegue")
        
        if segue.identifier == "showArticle" {
            print("here")
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                print("here2")
                print("there")
                let controller = (segue.destinationViewController as! UIViewController) as! ArticleViewController
                controller.details = object
                
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("ArticleListViewController - tableView: ", indexPath.row)
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["byline"]
        return cell
    }
    
    //@TODO: Format the cells

}