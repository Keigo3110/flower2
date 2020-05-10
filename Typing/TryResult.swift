//
//  TryResult.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/05/01.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation

class TryResult: UIViewController, GADInterstitialDelegate, AVAudioPlayerDelegate{
    
    @IBOutlet weak var gouhi: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var lpmLabel: UILabel!
    @IBOutlet weak var missLabel: UILabel!
    @IBOutlet weak var goHome: UIButton!
    @IBOutlet weak var newRank: UILabel!
    @IBOutlet weak var twitter: UIButton!
    
    @IBOutlet weak var flower: UIImageView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    var twiwpm:Double = 0
    var audioPlayer: AVAudioPlayer!
    var lpmNum:Double = 0
    var usedTimeNum:Double = 0
    var missNum:Int = 0
    var upOrDown2:Int = 0
    var new = 0
    let comment1 = ["おめでとう！","残念！","残念.."]
    let comment2 = ["1段昇格です！", "昇格ならず..", "1段降格です.."]
    let rankName = ["一級","初段","二段","三段","四段","五段","六段","七段","八段","九段","十段"]
    let flowers = ["花5", "花3", "花1"]
    var interstitial: GADInterstitial!
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
      self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
     
    }
    
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
        interstitial = createAndLoadInterstitial()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)
        // Do any additional setup after loading the view.
        gouhi.text = comment1[upOrDown2]
        comment.text = comment2[upOrDown2]
        lpmLabel.text = String(lpmNum)
        missLabel.text = String(missNum)
        newRank.text = rankName[new]
        flower.image = UIImage(named: flowers[upOrDown2])
    }
    
    @IBAction func goHome(_ sender: Any) {
        music(sound: "button")
        if interstitial.isReady {
                        interstitial.present(fromRootViewController: self)
                      } else {
                        print("Ad wasn't ready")
                        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                   
                      }
      
    }
    
    @IBAction func twitter(_ sender: Any) {
        let text = "あなたのフリックは1分間に\( lpmNum)文字、段位は\(rankName[new])です！\nhttps://lemonsmash.studio.design/members\n#flower"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let encodedText = encodedText,
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
