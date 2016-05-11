//
//  ArticleListViewController.swift
//  nytimesmostpopularapi
//
//  Created by Lauren Pully on 5/9/16.
//  Copyright © 2016 laurenpully. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ArticleListViewController: UITableViewController {
    
    var objects = [[String: String]]()
    var core_data_array = [NSManagedObject]()


    
    func parseJSON(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let byline = result["byline"].stringValue
            let publish_date = result["published_date"].stringValue
            
            var image_url = "NULL"  //initialize dummy variable
            if result["media"].arrayValue.count > 0{
                image_url = result["media"].arrayValue[0]["media-metadata"].arrayValue[0]["url"].rawString()!
            }
            
            let obj = ["title": title, "byline": byline, "publish_date": publish_date, "image_url": image_url]
            objects.append(obj)
            
            //saveData("test")
        }
        
        print("ArticleListViewController - done parsing json")
        
        tableView.reloadData()
    }
    
    func saveData(name:String)
    {
        print("ArticleListViewController - saveData")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //Data is in this case the name of the entity
        //let options = NSManagedObject(entity: entity!,
                                      //insertIntoManagedObjectContext:managedContext)
        
        //save to core data
        let core_object = NSEntityDescription.insertNewObjectForEntityForName("NYTimesApiEntity", inManagedObjectContext: managedContext) as! NYTimesApiEntity
        core_data_array.append(core_object)
        
        //var error: NSError?
        do {
            try managedContext.save()
        } catch let error {
            print("Could not cache the response \(error)")
        }
        //uncomment this line for adding the stored object to the core data array
        //core_data_array.append(options)
        print("just added to core data array")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print ("ArticleListViewController - viewDidLoad")
        print(self.navigationController?.tabBarItem.title)
        print(self.title)
        print(self.tabBarItem.title)
        print("testing nav controller in ArticleListViewController")
        print(self.navigationController)
        
        //register cell
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")

        
        print("registered cell")

        //read in API
        let apiURLString = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/" + self.tabBarItem.title! + "/7.json?api-key=98fa23b7d5b542f2be105b8384512928"
        
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
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //print("ArticleListViewController - tableView: ", indexPath.row)
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "DefaultCell")
        
        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel?.text = "Published: " + object["publish_date"]!
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        print("ArticleListViewController - tapped a cell")
        
        print(self.navigationController)
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let object = objects[indexPath.row]
            let controller = ArticleViewController()
            controller.details = object
            self.navigationController!.pushViewController(controller, animated: false)

        }
    }

    
}