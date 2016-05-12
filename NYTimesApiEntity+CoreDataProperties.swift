//
//  NYTimesApiEntity+CoreDataProperties.swift
//  nytimesmostpopularapi
//
//  Created by Lauren Pully on 5/11/16.
//  Copyright © 2016 laurenpully. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension NYTimesApiEntity {

    @NSManaged var title: String?
    @NSManaged var byline: String?
    @NSManaged var published_date: String?
    @NSManaged var image_url: String?
    @NSManaged var category: String?

}
