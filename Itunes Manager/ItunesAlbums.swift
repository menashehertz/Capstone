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
    
    var temporaryContext: NSManagedObjectContext
    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
    init() {
        temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        temporaryContext.persistentStoreCoordinator = sharedContext.persistentStoreCoordinator
    }
    
    func getAlbumsFromItunes (searchTerm: String, completionHandler: ( success: Bool, errorString: String) -> Void ) -> NSURLSessionDataTask? {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        guard let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            else {print("error in itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters"); return nil}

        let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album&limit=9"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            guard error == nil else {print("In Guard Error - ", error!.localizedDescription); return}
            
            // let theString:NSString = NSString(data: data!, encoding: NSASCIIStringEncoding)!
            // print(theString)
            
            do {
                guard let parsed = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
                    else {completionHandler(success: false, errorString: "error in NSJSONSerialization.JSONObjectWithData"); return }
                guard let results = parsed["results"] as? [[String : AnyObject]]
                    else {completionHandler(success: false, errorString: "error in converting the dictionary"); return }
                
                // Finally, process the the Json Dictionary
                self.listofAlbums.removeAll(keepCapacity: false)
                for result in results {
                    dispatch_async(dispatch_get_main_queue()){
                        let newAlbum = Album(theDict: result, context: self.temporaryContext)
                        self.listofAlbums.append(newAlbum)
                        }
                    // Not saving it because it is temporary albums, the aekected one will be saved
                }
                completionHandler(success: true, errorString: "No error")
            }
            catch let error as NSError {
                // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                print("A JSON parsing error occurred, here are the details:\n \(error)")
            }
        })
        
        task.resume()
        return task
        
    }

    
}

