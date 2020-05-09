//
//  SecondViewController.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/04/28.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation

class SecondViewController: UIViewController, GADInterstitialDelegate, AVAudioPlayerDelegate{
    
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
    @IBOutlet weak var bannerView: GADBannerView!

    
    
   
    var misss:String = ""
    var usedTimee:Double = 0
    var rrrecorddd:[Double] = [0,0,0]
    var wpmmm:String = ""
    var letterCount2:Double = 0
    var time = false
    var flowers = 0
    let flowersName = ["花1", "花2", "花3", "花4", "花5"]
    var interstitial: GADInterstitial!
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
    
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
         interstitial.delegate = self
         interstitial.load(GADRequest())
         return interstitial
       }
       
       func interstitialDidDismissScreen(_ ad: GADInterstitial) {
         interstitial = createAndLoadInterstitial()
         self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
       }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        interstitial = createAndLoadInterstitial()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
         self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)
        backHome.setBackgroundImage(UIImage(named:"木枠2"), for: .normal)
        back.setBackgroundImage(UIImage(named:"木枠2"), for: .normal)

        // Do any additional setup after loading the view.
        mis.text = misss
        usedTime.text = String(usedTimee)
        rrrecord.text = String(rrrecorddd[0])
        rrrecord2.text = String(rrrecorddd[1])
        rrrecord3.text = String(rrrecorddd[2])
        wpm.text = String(round(60*letterCount2/usedTimee))
        
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
        if interstitial.isReady {
                 interstitial.present(fromRootViewController: self)
               } else {
                print("Ad wasn't ready")
                 self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
               }
    }
    
   
 

}
