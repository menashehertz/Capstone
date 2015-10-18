//
//  Song.swift
//  Itunes Manager
//
//  Created by Steven Hertz on 10/14/15.
//  Copyright (c) 2015 Steven Hertz. All rights reserved.
//

import Foundation
import CoreData

// 2. Make Person available to Objective-C code
@objc(Song)


class Song : NSManagedObject{
    @NSManaged var kind: String
    @NSManaged var collectionId: NSNumber
    @NSManaged var trackId: NSNumber
    @NSManaged var trackName: String
    @NSManaged var trackViewUrl: String
    @NSManaged var previewUrl: String
    @NSManaged var artworkUrl30: String
    @NSManaged var album: Album?
    // let trackPrice: String

    
    // 5. Include this standard Core Data init method.
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    

    /* 6. The two argument init method
    *
    * The Two argument Init method. The method has two goals:
    *  - insert the new Person into a Core Data Managed Object Context
    *  - initialze the Person's properties from a dictionary
    */
    
    
    init(theDict: [String: AnyObject ], context: NSManagedObjectContext) {
        
        // Get the entity associated with the "Person" type.  This is an object that contains
        // the information from the Model.xcdatamodeld file. We will talk about this file in
        // Lesson 4.
        let entity =  NSEntityDescription.entityForName("Song", inManagedObjectContext: context)!
        
        // Now we can call an init method that we have inherited from NSManagedObject. Remember that
        // the Person class is a subclass of NSManagedObject. This inherited init method does the
        // work of "inserting" our object into the context that was passed in as a parameter
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        // After the Core Data work has been taken care of we can init the properties from the
        // dictionary. This works in the same way that it did before we started on Core Data
        
        self.kind = theDict["kind"] as! String
        self.collectionId = theDict["collectionId"] as! Int
        self.trackId = theDict["trackId"] as! Int
        self.trackName = theDict["trackName"] as! String
        self.trackViewUrl = theDict["trackViewUrl"] as! String
        // self.trackPrice = theDict["trackPrice"] as! String
        self.previewUrl = theDict["previewUrl"] as! String
        self.artworkUrl30 = theDict["artworkUrl30"] as! String
}

}
