//
//  SongDetailViewController.swift
//  Itunes Manager
//
//  Created by Steven Hertz on 10/19/15.
//  Copyright © 2015 Steven Hertz. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class SongDetailViewController: UIViewController {
    
//    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
//    
//    var m = AVPlayerViewController()
//
    
    var song: Song!
    
    var songNoteArray : [SongNote]!
    
    var indexIntoArray : Int?

    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var previewUrlLabel: UILabel!
    
    @IBOutlet weak var notesText: UITextField!
    
    @IBAction func saveNotes(sender: AnyObject) {
        
        
        if let indexIntoArray = indexIntoArray {
            songNoteArray.removeAtIndex(indexIntoArray)
        }
        
        let sn1 = SongNote(trackId: song.trackId, note: notesText.text!)
        
        songNoteArray.append(sn1)
        
        // Archive the graph any time this list of actors is displayed.
        NSKeyedArchiver.archiveRootObject(songNoteArray, toFile: filePath)

        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Unarchive the graph when the list is first shown
        self.songNoteArray = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [SongNote] ?? [SongNote]()

        
       print(song.previewUrl)
        
        trackNameLabel.text = song.trackName
        
        previewUrlLabel.text = song.previewUrl
        
        
//        let sn1 = SongNote(trackId: 158816067, note: "This is my first note")
//        let sn2 = SongNote(trackId: 158816065, note: "This is my second note")
//        let sn3 = SongNote(trackId: 158816060, note: "This is my third note")
//        
//        // songNoteArray  = []
//        
//        

        
        
        
//        let arrayDictTrk = songNoteArray.map({$0.trackId })
//        
//        
//        let indexOfDictTrkValueFromArray = arrayDictTrk.indexOf(song.trackId)
        
        
        let indexOfDictTrkValue = (songNoteArray.map({$0.trackId})).indexOf(song.trackId)
        
        if let indexOfDictTrkValue = indexOfDictTrkValue {
            notesText.text = songNoteArray[indexOfDictTrkValue].note
            indexIntoArray = indexOfDictTrkValue
            print(songNoteArray[indexOfDictTrkValue].note)
        }
       
  
        // Do any additional setup after loading the view.
    }

    
    
    // MARK: - Saving the array. Helper.
    
    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        return url.URLByAppendingPathComponent("notesArray").path!
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
