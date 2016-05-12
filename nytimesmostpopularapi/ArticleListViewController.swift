//
//  ArticleListViewController.swift
//  nytimesmostpopularapi
//
//  Created by Lauren Pully on 5/9/16.
//  Copyright © 2016 laurenpully. All rights reserved.
//
// Detailed view controller to display information about an article
//

import Foundation
import UIKit
import CoreData

class ArticleListViewController: UITableViewController {
    
    var objects: [NYTimesApiEntity]!
    var core_data_array: [NYTimesApiEntity]!
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    
    func parseJSON(json: JSON) {
        
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let byline = result["byline"].stringValue
            let publish_date = result["published_date"].stringValue
            
            var image_url = "NULL"  //initialize dummy variable
            if result["media"].arrayValue.count > 0{ //pull the largest image for each article
                image_url = result["media"].arrayValue[0]["media-metadata"].arrayValue[result["media"].arrayValue[0]["media-metadata"].count - 1]["url"].rawString()!
            }
            
            addItemIntoCoreData(title, myByline: byline, myPublish_date: publish_date, myImage_url: image_url)
        }
        
        print("ArticleListViewController - done parsing json")
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("saved into core data")
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
        else{
            print("nothing to save")
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print ("ArticleListViewController - viewDidLoad")
        
        //register cell
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        print("registered cell")
        
        //startCoreData and load saved data
        startCoreData()
        loadSavedData()
        print("just loaded core data: ", core_data_array.count)
        if(core_data_array.count == 0){
            print("nothing for this category, querying API")
            queryAPI()
        }
        
        //assign core data to objects and load table
        objects = core_data_array
        tableView.reloadData()
        
        //add in pull to refresh capabilities
        refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refreshData:", forControlEvents: .ValueChanged)
        self.refreshControl = self.refreshControl
        
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
        let object = objects[indexPath.row]
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
        
        let fetch = NSFetchRequest(entityName: "NYTimesApiEntity")
        let sort = NSSortDescriptor(key: "published_date", ascending: false)
        let predicate = NSPredicate(format: "category == %@", self.tabBarItem.title!)
        fetch.predicate = predicate
        fetch.sortDescriptors = [sort]
        fetch.fetchBatchSize = 20
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: managedObjectContext, sectionNameKeyPath: "title", cacheName: nil)
        
        do {
            let results =
                try managedObjectContext.executeFetchRequest(fetch)
            core_data_array = results as! [NYTimesApiEntity]
            print("loaded data")
        } catch {
            print("Fetch failed")
        }
        
        print("end loadSavedData")
    }
    
    func deleteSavedData(cat: String) {
        print("deleteSavedData")
        
        //setup fetching criteria
        let fetch = NSFetchRequest(entityName: "NYTimesApiEntity")
        let predicate = NSPredicate(format: "category == %@", cat)
        fetch.predicate = predicate
        let sort = NSSortDescriptor(key: "published_date", ascending: false)
        fetch.sortDescriptors = [sort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: managedObjectContext, sectionNameKeyPath: "title", cacheName: nil)
        
        do {
            let results =
                try managedObjectContext.executeFetchRequest(fetch)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedObjectContext.deleteObject(managedObjectData)
            }
        } catch {
            print("Fetch failed")
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
    
    func refreshData(sender:AnyObject) {
        print("ArticleListViewController - pulled to refresh")
        
        queryAPI()
        
        refreshControl!.endRefreshing()
    }
    
    func queryAPI(){
        deleteSavedData(self.tabBarItem.title!)
        
        core_data_array = [NYTimesApiEntity]()
        
        //read in API
        let apiURLString = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/" + self.tabBarItem.title! + "/7.json?api-key=98fa23b7d5b542f2be105b8384512928"
        
        print ("MasterView - queryAPI set apiURLString to: ", apiURLString)
        
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
        
        //assign core data to objects and load table
        objects = core_data_array
        print(objects.count)
        print(core_data_array.count)
        tableView.reloadData()
        saveContext()
    }
    
}