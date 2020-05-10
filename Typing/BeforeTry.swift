//
//  BeforeTry.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/05/01.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit
import AVFoundation

class BeforeTry: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var danni: UILabel!
    @IBOutlet weak var jouken1: UILabel!
    @IBOutlet weak var jouken2: UILabel!
    @IBOutlet weak var no: UIButton!
    @IBOutlet weak var yes: UIButton!
    var rankNum = 0
    var audioPlayer: AVAudioPlayer!
    let rankName = ["現在の段位は\n一級\nビギナー","現在の段位は\n初段\nビギナー","現在の段位は\n二段\nアマチュア","現在の段位は\n三段\nアマチュア","現在の段位は\n四段\nベテラン","現在の段位は\n五段\nベテラン","現在の段位は\n六段\nプロ","現在の段位は\n七段\nプロ","現在の段位は\n八段\n師範","現在の段位は\n九段\n師範","現在の段位は\n殿堂入り\nゴッド"]
    
    let up = ["80文字/分","110文字/分","130文字/分","150文字/分","170文字/分","190文字/分","210文字/分","220文字/分","230文字/分","250文字/分","なし"]
    
    let down = ["なし","80文字/分","110文字/分","130文字/分","150文字/分","170文字/分","190文字/分","210文字/分","220文字/分","230文字/分","なし"]
    
    var tryCount = 0
    
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
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)


        // Do any additional setup after loading the view.
        
        danni.text = rankName[rankNum]
        jouken1.text = up[rankNum]
        jouken2.text = down[rankNum]
        
    }
    
    @IBAction func NoAction(_ sender: Any) {
        music(sound: "button")
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func YesAction(_ sender: Any) {
        music(sound: "button")
        tryCount += 1
        let top = self.presentingViewController as! Top
        top.tryCount = tryCount
        top.viewDidLoad()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toTry"{
        let next = segue.destination as! Try
        next.rankNum2 = rankNum
    }
    }
    
    
}
