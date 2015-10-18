//
//  ItunesAlbums.swift
//  Itunes Manager
//
//  Created by Steven Hertz on 10/15/15.
//  Copyright © 2015 Steven Hertz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ItunesAlbums {
    
    static let oneSession = ItunesAlbums()
    
    enum Error : ErrorType {
        case InvalidJson
        case KeyNotFound
    }
    
    var listofAlbums = [Album]()
    
    // MARK: - Core Data Convenience
    
    // Temporary Context?
    //
    // This view controller may temporarily download quite a few actors while the user
    // is typing in text.
    //
    // If the user types "ll" for example, that would find "LL Cool J", "Bill Murray", and
    // many others. We don't want to add all of those actors to the main context. So we will
    // put them in this temporary context instead.
    
    var temporaryContext: NSManagedObjectContext!
    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
    init() {
        temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        temporaryContext.persistentStoreCoordinator = sharedContext.persistentStoreCoordinator
    }
    
    func setUpSharedContext() {
        // Set the temporary context
        temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        temporaryContext.persistentStoreCoordinator = sharedContext.persistentStoreCoordinator
    }
    
    // func getAlbumsFromItunes(completionHandler: ( success: Bool, errorString: String) -> Void) {
    func getAlbumsFromItunes (searchTerm: String, completionHandler: ( success: Bool, errorString: String) -> Void) {
        
        print("In getAlbums function search term is  \(searchTerm)")
        

        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        guard let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            else {print("error in itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters"); return}

        let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album&limit=9"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            print("Task completed")
            
            guard error == nil else {print("In Guard Error - ", error!.localizedDescription); return}
            
            // let theString:NSString = NSString(data: data!, encoding: NSASCIIStringEncoding)!
            //print(theString)
            
            do {
                // Try parsing some valid JSON
                guard let parsed = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
                    else {print("error in NSJSONSerialization.JSONObjectWithData"); return}
                guard let results = parsed["results"] as? [[String : AnyObject]]
                    else {print("error in converting the dictionary"); return}
                
                self.listofAlbums.removeAll(keepCapacity: false)
                for result in results {
                    //print("\n\n----\n\n")
                    // print(result["collectionName"]!)
                    dispatch_async(dispatch_get_main_queue()){
                        let newAlbum = Album(theDict: result, context: self.temporaryContext)
                        self.listofAlbums.append(newAlbum)
                        }
//                    dispatch_async(dispatch_get_main_queue()){
//                        CoreDataStackManager.sharedInstance().saveContext()
//                    }
                }
                completionHandler(success: true, errorString: "No error")
            }
            catch let error as NSError {
                // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                print("A JSON parsing error occurred, here are the details:\n \(error)")
            }
        })
        
        // The task is just an object with all these properties set
        // In order to actually make the web request, we need to "resume"
        task.resume()
        
    }

    
}

