//
//  audioView.swift
//  PersonalSpotify
//
//  Created by Pravin Biradar on 4/8/17.
//  Copyright © 2017 pbirada1. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class audioView:UIViewController{
    
    var image = UIImage()
    var songTitle = String()
    var previewURL = String()
    
    @IBOutlet weak var backGround: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!

    @IBOutlet weak var pausePlay: UIButton!
    
    @IBAction func playAction(_ sender: Any) {
        if player.isPlaying{
            pausePlay.setTitle("Play", for: .normal)
            player.pause()
        }else{
            player.play()
            pausePlay.setTitle("Pause", for: .normal)
        }
        
        
        
    }
    override func viewDidLoad() {
        mainLabel.text = songTitle
        backGround.image = image
        mainImage.image = image
        downloadFile(url: URL(string: previewURL)!)
    }
    
    func downloadFile(url:URL){
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (customURL, response, error) in
            self.play(url: customURL!)
        })
        
        downloadTask.resume()
        
    }
    
    func play(url:URL){
        do{
            try player = AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        }catch{
            
        
        }
    }

}
