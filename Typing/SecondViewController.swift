//
//  SecondViewController.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/04/28.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController, AVAudioPlayerDelegate{
    
    @IBOutlet weak var mis: UILabel!
    @IBOutlet weak var usedTime: UILabel!
    @IBOutlet weak var rrrecord: UILabel!
    @IBOutlet weak var rrrecord2: UILabel!
    @IBOutlet weak var rrrecord3: UILabel!
    @IBOutlet weak var wpm: UILabel!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var backHome: UIButton!
    @IBOutlet weak var timeOut: UILabel!
    
    @IBOutlet weak var flower: UIImageView!
    
    @IBOutlet weak var Twitter: UIButton!
    

    @IBOutlet weak var line: UIButton!
    
    
    var twiwpm:Double = 0
    var misss:String = ""
    var usedTimee:Double = 0
    var rrrecorddd:[Double] = [0,0,0]
    var wpmmm:String = ""
    var letterCount2:Double = 0
    var time = false
    var flowers = 0
    let flowersName = ["花1", "花2", "花3", "花4", "花5"]
    var audioPlayer: AVAudioPlayer!
    
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
        backHome.setBackgroundImage(UIImage(named:"木枠2"), for: .normal)
        back.setBackgroundImage(UIImage(named:"木枠2"), for: .normal)

        // Do any additional setup after loading the view.
        mis.text = misss
        usedTime.text = String(usedTimee)
        rrrecord.text = String(rrrecorddd[0])
        rrrecord2.text = String(rrrecorddd[1])
        rrrecord3.text = String(rrrecorddd[2])
         twiwpm = round(60*letterCount2/usedTimee)
        wpm.text = String(twiwpm)
       
        
        if time == true{
            music(sound: "時間切れ")
            timeOut.text = "残念！\n時間切れ！！"
            flower.image = UIImage(named: flowersName[flowers])
        }else{
            music(sound: "まる")
            timeOut.text = "満開！\n大変素晴らしいです"
            flower.image = UIImage(named: flowersName[flowers])
        }
        
        
            }
    
    
    
    @IBAction func back(_ sender: Any) {
        music(sound: "button")
        let vc1 = self.presentingViewController as! ViewController
        vc1.count = 0
        vc1.abc = true
        vc1.quesCount = 0
        vc1.usedTime1 = 0
        vc1.letterCount = 0
        vc1.timerr = [30,0,0]
        vc1.stop = false
        vc1.flowers = 0
        
        vc1.loadView()
        vc1.viewDidLoad()
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backtoHome(_ sender: Any) {
        music(sound: "button")
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
               
    }
    
    
    @IBAction func Twitter(_ sender: Any) {
        let text = "あなたのフリック速度は1分間に\( twiwpm)文字です！\nhttps://lemonsmash.studio.design/members\n#flower"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let encodedText = encodedText,
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func line(_ sender: Any) {
        
        let urlscheme: String = "https://line.me/R/msg/text"
        let message = "あなたのフリック速度は1分間に\( twiwpm)文字です！\nhttps://lemonsmash.studio.design/members\n#flower"

        // line:/msg/text/(メッセージ)
        let urlstring = urlscheme + "/" + message

        // URLエンコード
        guard let  encodedURL = urlstring.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
          return
        }

        // URL作成
        guard let url = URL(string: encodedURL) else {
          return
        }

        if UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (succes) in
              //  LINEアプリ表示成功
            })
          }else{
            UIApplication.shared.openURL(url)
          }
        }
//            else {
//          // LINEアプリが無い場合
//          let alertController = UIAlertController(title: "エラー",
//                                                  message: "LINEがインストールされていません",
//                                                  preferredStyle: UIAlertControllerStyle.alert)
//          alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
//          present(alertController,animated: true,completion: nil)
//        }
    }
    
}
