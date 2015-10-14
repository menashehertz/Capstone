//
//  ItunesTableViewController.swift
//  Itunes Manager
//
//  Created by Steven Hertz on 10/13/15.
//  Copyright © 2015 Steven Hertz. All rights reserved.
//

import UIKit

class ItunesTableViewController: UITableViewController {
    
    // an array of dictionaries...
    var songs = [
        ["title": "Here Comes the Sun", "price": "$12.99", "thumbnailImageURL": "http://is1.mzstatic.com/image/thumb/Music/17/07/36/mzi.ldnorbao.tif/60x60bb-85.jpg", "largeImageURL": "http://is5.mzstatic.com/image/thumb/Music/17/07/36/mzi.ldnorbao.tif/100x100bb-85.jpg", "itemURL": "https://itunes.apple.com/us/album/here-comes-the-sun/id401186200?i=401187150&uo=4", "artistURL": "https://itunes.apple.com/us/artist/the-beatles/id136975?uo=4", "collectionId": 401186200 ],
        ["title": "Let It Be", "price": "$12.99", "thumbnailImageURL": "http://is1.mzstatic.com/image/thumb/Music/23/f0/1a/mzi.ojxbpuxu.tif/60x60bb-85.jpg", "largeImageURL": "http://is1.mzstatic.com/image/thumb/Music/23/f0/1a/mzi.ojxbpuxu.tif/100x100bb-85.jpg", "itemURL": "https://itunes.apple.com/us/album/let-it-be/id401151866?i=401151904&uo=4", "artistURL": "https://itunes.apple.com/us/artist/the-beatles/id136975?uo=4", "collectionId": 401151866 ],
        ["title": "Hey Jude", "price": "$12.99", "thumbnailImageURL": "http://is1.mzstatic.com/image/thumb/Music/64/3c/dd/mzi.jmeqkgdm.tif/60x60bb-85.jpg", "largeImageURL": "http://is1.mzstatic.com/image/thumb/Music/64/3c/dd/mzi.jmeqkgdm.tif/100x100bb-85.jpg", "itemURL": "https://itunes.apple.com/us/album/hey-jude/id400835735?i=400835962&uo=4", "artistURL": "https://itunes.apple.com/us/artist/the-beatles/id136975?uo=4"	, "collectionId": 400835735 ]
    ]
    
    var musicAlbumArray = [MusicAlbum]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        for item in songs {
            var musicAlbum = MusicAlbum(theDict: item)
            musicAlbumArray.append(musicAlbum)
        }
        
        print(musicAlbumArray[0].title)
        

        print("From viewDidLoad")
        searchItunesFor("smythe")


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions Getting Itunes Data
    
    /* Search Itunes */
    func searchItunesFor(searchTerm: String) {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            
            // if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                print("Task completed")
                
                guard error == nil else {print(error!.localizedDescription); return}
                
                //                if(error != nil) {
                //                    // If there is an error in the web request, print it to the console
                //                    print(error!.localizedDescription)
                //                }
                
                // let theString:NSString = NSString(data: data!, encoding: NSASCIIStringEncoding)!
                // print(theString)
                
                do {
                    // Try parsing some valid JSON
                    let parsed = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String : AnyObject]
                    guard let results = parsed["results"] as? [[String : AnyObject]]  else {print("error in converting the dictionary"); return}
                    // let results = parsed["results"] as! [[String : AnyObject]]
                    for result in results {
                        print("\n\n----\n\n")
                        print(result["description"]!)
                        print("formattedPrice", result["formattedPrice"]!)
                        print("trackName", result["trackName"]!)
                        print("artworkUrl60", result["artworkUrl60"]!)
                        
                        
                    }
                    // print(parsed)
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
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("in numberOfSectionsInTableView")
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("in numberOfRowsInSection")
        return musicAlbumArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("in cell for row at index path")
        let currentRow = musicAlbumArray[indexPath.row]
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! AlbumTableViewCell
            cell.cellLabel.text = currentRow.title
             return cell
           
        } else {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        // cell.textLabel?.text = String(indexPath.row)
        cell.textLabel?.text = currentRow.title
        
        cell.imageView?.image = UIImage(named: "Blank52")
        
        let imageURL = NSURL(string: currentRow.thumbnailImageURL)
        if let imageData = NSData(contentsOfURL: imageURL!) {
             cell.imageView?.image = UIImage(data: imageData)
            print("------------------------in data from url")
        } else {
            print("========================= not")
            
        }
         return cell
    }

        // let xx = UIImage(contentsOfFile: currentRow.thumbnailImageURL)
        // cell.imageView?.image = xx
        

        
//        let thumbnailURLString = currentRow.thumbnailImageURL
//        print("xxx", thumbnailURLString)
//        let thumbnailURL = NSURL(string: thumbnailURLString)!
//        if let dataFromURL = NSData(contentsOfURL: thumbnailURL) {
//            print("------------------------in data from url")
//            let img = UIImage(data: dataFromURL)
//            cell.imageView?.image = img
//        } else {
//            print("========================= not")
//        }


       
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("We selected a row, Great! Row clicked was \(indexPath.row)")
        
    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
//        let album = self.albums[indexPath.row]
//        
//        // Get the formatted price string for display in the subtitle
//        cell.detailTextLabel?.text = album.price
//        // Update the textLabel text to use the title from the Album model
//        cell.textLabel?.text = album.title
//        
//        // Start by setting the cell's image to a static file
//        // Without this, we will end up without an image view!
//        cell.imageView?.image = UIImage(named: "Blank52")
//        
//        let thumbnailURLString = album.thumbnailImageURL
//        let thumbnailURL = NSURL(string: thumbnailURLString)!
//        
//        // If this image is already cached, don't re-download
//        if let img = imageCache[thumbnailURLString] {
//            cell.imageView?.image = img
//        }
//        else {
//            // The image isn't cached, download the img data
//            // We should perform this in a background thread
//            let request: NSURLRequest = NSURLRequest(URL: thumbnailURL)
//            let mainQueue = NSOperationQueue.mainQueue()
//            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
//                if error == nil {
//                    // Convert the downloaded data in to a UIImage object
//                    let image = UIImage(data: data!)
//                    // Store the image in to our cache
//                    self.imageCache[thumbnailURLString] = image
//                    // Update the cell
//                    dispatch_async(dispatch_get_main_queue(), {
//                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
//                            cellToUpdate.imageView?.image = image
//                        }
//                    })
//                }
//                else {
//                    print("Error: \(error!.localizedDescription)")
//                }
//            })
//        }
//        return cell
//    }
//    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
