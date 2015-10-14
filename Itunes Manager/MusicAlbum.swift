//
//  MusicAlbum.swift
//  Itunes Manager
//
//  Created by Steven Hertz on 10/13/15.
//  Copyright © 2015 Steven Hertz. All rights reserved.
//

import Foundation



struct MusicAlbum {
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



    static func loadDefault(results: NSArray) -> [MusicAlbum] {
        // Create an empty array of Albums to append to from this list
        
        
        var musicAlbumDict: [String: AnyObject]

        var albums = [MusicAlbum]()
        
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

    static func albumsWithJSON(results: NSArray) -> [MusicAlbum] {
        // Create an empty array of Albums to append to from this list
        var albums = [MusicAlbum]()
        
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
    
}