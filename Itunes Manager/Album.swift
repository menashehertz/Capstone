//
//  MusicAlbum.swift
//  Itunes Manager
//
//  Created by Steven Hertz on 10/13/15.
//  Copyright © 2015 Steven Hertz. All rights reserved.
//

import Foundation
import CoreData

// 2. Make Person available to Objective-C code
@objc(Album)


class Album : NSManagedObject{
    @NSManaged var collectionId: NSNumber
    @NSManaged var collectionName: String
    @NSManaged var artworkUrl60: String
    @NSManaged var artworkUrl100: String
    @NSManaged var collectionViewUrl: String
    @NSManaged var songs: [Song]
    //let collectionPrice: String
    //let artistViewUrl: String
    
    
    // 5. Include this standard Core Data init method.
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    /**
    * 6. The two argument init method
    *
    * The Two argument Init method. The method has two goals:
    *  - insert the new Person into a Core Data Managed Object Context
    *  - initialze the Person's properties from a dictionary
    */
        
    init(theDict: [String: AnyObject ], context: NSManagedObjectContext) {
        
        // Get the entity associated with the "Person" type.  This is an object that contains
        // the information from the Model.xcdatamodeld file. We will talk about this file in
        // Lesson 4.
        let entity =  NSEntityDescription.entityForName("Album", inManagedObjectContext: context)!
        
        // Now we can call an init method that we have inherited from NSManagedObject. Remember that
        // the Person class is a subclass of NSManagedObject. This inherited init method does the
        // work of "inserting" our object into the context that was passed in as a parameter
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        
        // After the Core Data work has been taken care of we can init the properties from the
        // dictionary. This works in the same way that it did before we started on Core Data

        
        self.collectionId =  theDict["collectionId"] as! Int
        self.collectionName = theDict["collectionName"] as! String
       // self.collectionPrice = theDict["collectionPrice"] as! String
        self.artworkUrl60 = theDict["artworkUrl60"] as! String
        self.artworkUrl100 = theDict["artworkUrl100"] as! String
        self.collectionViewUrl =  theDict["collectionViewUrl"] as! String
        //self.artistViewUrl =  theDict["artistViewUrl"] as! String
    }

/*
    struct Album {
        let title: String
        let price: String
        let thumbnailImageURL: String
        let largeImageURL: String
        let itemURL: String
        let artistURL: String
        let collectionId: Int
        
        init(theDict: [String: AnyObject ]) {
            self.title = theDict["title"] as! String
            self.price = theDict["price"] as! String
            self.thumbnailImageURL = theDict["thumbnailImageURL"] as! String
            self.largeImageURL = theDict["largeImageURL"] as! String
            self.itemURL =  theDict["itemURL"] as! String
            self.artistURL =  theDict["artistURL"] as! String
            self.collectionId =  theDict["collectionId"] as! Int
        }
        
        


    static func loadDefault(results: NSArray) -> [Album] {
        // Create an empty array of Albums to append to from this list
        
        
        var musicAlbumDict: [String: AnyObject]

        var albums = [Album]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in results {
                
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String
                    if price == nil {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                    }
                }
                
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                if let collectionId = result["collectionId"] as? Int {
//                    var newAlbum = MusicAlbum(name: name!,
//                        price: price!,
//                        thumbnailImageURL: thumbnailURL,
//                        largeImageURL: imageURL,
//                        itemURL: itemURL!,
//                        artistURL: artistURL,
//                        collectionId: collectionId)
//                    albums.append(newAlbum)
                }
            }
        }
        return albums
    }

    static func albumsWithJSON(results: NSArray) -> [Album] {
        // Create an empty array of Albums to append to from this list
        var albums = [Album]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in results {
                
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String
                    if price == nil {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                    }
                }
                
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                if let collectionId = result["collectionId"] as? Int {
//                    var newAlbum = MusicAlbum(name: name!,
//                        price: price!,
//                        thumbnailImageURL: thumbnailURL,
//                        largeImageURL: imageURL,
//                        itemURL: itemURL!,
//                        artistURL: artistURL,
//                        collectionId: collectionId)
//                    albums.append(newAlbum)
                }
            }
        }
        return albums
    }
 */
}