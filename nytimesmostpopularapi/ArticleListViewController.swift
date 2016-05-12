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
    var core_data_array = [NYTimesApiEntity]()
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!

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
            addItemIntoCoreData(title, myByline: byline, myPublish_date: publish_date, myImage_url: image_url)
        }
        
        print("ArticleListViewController - done parsing json")
        tableView.reloadData()
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func addItemIntoCoreData(myTitle: String, myByline: String, myPublish_date: String, myImage_url: String){
        print("addItemIntoCoreData")
        
        let item = NSEntityDescription.insertNewObjectForEntityForName("NYTimesApiEntity", inManagedObjectContext: self.managedObjectContext) as? NYTimesApiEntity
        item?.byline = myByline
        item?.title = myTitle
        item?.published_date = myPublish_date
        item?.image_url = myImage_url
        item?.category = self.tabBarItem.title!
        
        core_data_array.append(item!)
        
        print("end addItemIntoCoreData")

    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print ("ArticleListViewController - viewDidLoad")
        
        //register cell
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        print("registered cell")
        
        //startCoreData
        startCoreData()
        //loadSavedData()

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
        
        //save core data
        print("about to save core data")
        saveContext()
        
        print("MasterView - end viewDidLoad")

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tabBarItem.title!
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "DefaultCell")
        
        /*let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel?.text = "Published: " + object["publish_date"]!*/
        let object = core_data_array[indexPath.row]
        cell.textLabel!.text = object.title
        cell.detailTextLabel?.text = "Published: " + object.published_date!
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
    
    //core data functions
    func getDocumentsDirectory() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[0]
    }
    
    func startCoreData() {
        print("startCoreData")

        let modelURL = NSBundle.mainBundle().URLForResource("nytimesmostpopularapi", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
        

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        

        let url = getDocumentsDirectory().URLByAppendingPathComponent("nytimesmostpopularapi.sqlite")
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
            
            managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        } catch {
            print("Failed to initialize the application's saved data")
            return
        }
    }
    
    func loadSavedData() {
        print("loadSavedData")
        if fetchedResultsController == nil {
            let fetch = NSFetchRequest(entityName: "NYTimesApiEntity")
            let sort = NSSortDescriptor(key: "NYTimesApiEntity.category", ascending: true)
            fetch.sortDescriptors = [sort]
            fetch.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: managedObjectContext, sectionNameKeyPath: "NYTimesApiEntity.category", cacheName: nil)
            //fetchedResultsController.delegate = self
        }
        
        //fetchedResultsController.fetchRequest.predicate = commitPredicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
}