//
//  startViewController.swift
//  Typing
//
//  Created by 大原拓真 on 2020/05/07.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit
import AVFoundation

class start: UIViewController, AVAudioPlayerDelegate {
    

    @IBOutlet weak var flower: UIImageView!
    @IBOutlet weak var happa: UIImageView!
    @IBOutlet weak var Button: UIButton!
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var tapstart: UILabel!
    
    func music(sound: String) {
        let audioPath = Bundle.main.path(forResource: sound, ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        var audioError:NSError?
           do {
               audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
           } catch let error as NSError {
               audioError = error
               audioPlayer = nil
           }
           if let error = audioError {
                          print("Error")
                      }
           audioPlayer.delegate = self
                      audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        flash()
        flower.image = UIImage(named: "花5")
        happa.image = UIImage(named:"葉っぱ")
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)
        
       

        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func start(_ sender: Any) {
        music(sound: "button")
    }
    
    func flash() {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .repeat, animations: {
            self.tapstart.alpha = 0.0
        }, completion: { (_) in
            self.tapstart.alpha = 1.0
        })
    }
}
