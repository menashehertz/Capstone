//
//  SongDetailViewController.swift
//  Itunes Manager
//
//  Created by Steven Hertz on 10/19/15.
//  Copyright © 2015 Steven Hertz. All rights reserved.
//

import UIKit

class SongDetailViewController: UIViewController {
    
    var song: Song!
    
    var songNoteArray : [SongNote]!
    
    var indexIntoArray : Int?

    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var previewUrlLabel: UILabel!
    
    @IBOutlet weak var notesText: UITextField!
    
    @IBAction func saveNotes(sender: AnyObject) {
        
        
        if let indexIntoArray = indexIntoArray {
            ItunesSongs.oneSession.songNoteArray.removeAtIndex(indexIntoArray)
        }
        
        let sn1 = SongNote(trackId: song.trackId, note: notesText.text!)
        
        ItunesSongs.oneSession.songNoteArray.append(sn1)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(song.trackId)
        
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
        
        
        let indexOfDictTrkValue = (ItunesSongs.oneSession.songNoteArray.map({$0.trackId})).indexOf(song.trackId)
        
        if let indexOfDictTrkValue = indexOfDictTrkValue {
            notesText.text = ItunesSongs.oneSession.songNoteArray[indexOfDictTrkValue].note
            indexIntoArray = indexOfDictTrkValue
            print(ItunesSongs.oneSession.songNoteArray[indexOfDictTrkValue].note)
        }
       
        
        
        
        
        
        

        // Do any additional setup after loading the view.
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
