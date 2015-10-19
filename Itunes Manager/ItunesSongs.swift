//
//  ItunesSongs.swift
//  Itunes Manager
//
//  Created by Steven Hertz on 10/14/15.
//  Copyright (c) 2015 Steven Hertz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ItunesSongs {
    
    static let oneSession = ItunesSongs()
    
    enum Error : ErrorType {
        case InvalidJson
        case KeyNotFound
    }
    
    var currentAlbum : Album?
    var collectionId : NSNumber = 111
    var listofSongs = [Song]()
    
    var songNoteArray = [SongNote]()
    
    
    // MARK: - Core Data Convenience
    
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
        }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
 
    func getSongsFromItunes(completionHandler: ( success: Bool, errorString: String) -> Void) {
    //func getSongsFromItunes () {
       
        print("In getSongs function collection id is  \(collectionId)")
        let urlPath = "https://itunes.apple.com/lookup?id=\(collectionId)&entity=song&limit=9"
        
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            print("Task completed")
            
            guard error == nil else {print("In Guard Error - ", error!.localizedDescription); return}
            
            // let theString:NSString = NSString(data: data!, encoding: NSASCIIStringEncoding)!
            // print(theString)
            
            do {
                // Try parsing some valid JSON
                guard let parsed = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject]
                    else {print("error in NSJSONSerialization.JSONObjectWithData"); return}
                guard let results = parsed["results"] as? [[String : AnyObject]]
                    else {print("error in converting the dictionary"); return}

                self.listofSongs.removeAll(keepCapacity: false)
                for result in results {
                    //print("\n\n----\n\n")
                    if let wrapperType = result["wrapperType"] as? String {
                     if wrapperType == "track" {
                        print(result["trackName"]!)
                        dispatch_async(dispatch_get_main_queue()){
                            var newSong = Song(theDict: result, context: self.sharedContext)
                            newSong.album = self.currentAlbum
                            self.listofSongs.append(newSong)
                        }
                        dispatch_async(dispatch_get_main_queue()){
                            self.saveContext()
                        }
                        }
                    }
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

