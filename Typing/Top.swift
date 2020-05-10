//
//  Top.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/04/29.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation




class Top: UIViewController, AVAudioPlayerDelegate{
    
   
    let exp = [0,0,1,2,4,7,10,20,30,40,50,60,70,80,90,100,
    110,120,130,140,150,160,170,180,190,200,
    210,220,230,240,250,260,270,280,290,300,
    310,320,330,340,350,360,370,380,390,400,
    410,420,430,440,450,460,470,480,490,500,
    510,520,530,540,550,560,570,580,590,600,
    610,620,630,640,650,660,670,680,690,700,
    710,720,730,740,750,760,770,780,790,800,
    810,820,830,840,850,860,870,880,890,900,
    910,920,930,940,950]
    
    var level:Int = 0
    var expPoint2 = 0
    var tryCount = 0
    var audioPlayer: AVAudioPlayer!
    let userDefaults1 = UserDefaults.standard
    
    @IBOutlet weak var word: UIButton!
    @IBOutlet weak var sentence: UIButton!
    @IBOutlet weak var English: UIButton!
    @IBOutlet weak var anki: UIButton!
    @IBOutlet weak var exppp: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var toTry: UIButton!
    @IBOutlet weak var minus: UILabel!
    
    
    @IBOutlet weak var happa: UIImageView!
    @IBOutlet weak var aaaaa: UIImageView!
    let UD = UserDefaults.standard
    let calendar = Calendar.current
    let nowDay = Date(timeIntervalSinceNow: 60 * 60 * 9)
    let pastDay1 = Date(timeIntervalSinceNow: -60 * 60 * 24)
    var judge = false
    
    @IBOutlet weak var bannerView: GADBannerView!
    
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
    
    
   let rankName = ["一級","初段","二段","三段","四段","五段","六段","七段","八段","九段","殿堂入り"]
    
   var rankNumber = 0
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
       
        
        UD.register(defaults: ["today" : nowDay])
        word.setBackgroundImage(UIImage(named:"単語"), for: .normal)
        sentence.setBackgroundImage(UIImage(named:"長文"), for: .normal)
        English.setBackgroundImage(UIImage(named:"英語"), for: .normal)
        anki.setBackgroundImage(UIImage(named:"暗記"), for: .normal)
        toTry.setBackgroundImage(UIImage(named:"syodan"), for: .normal)
        
        aaaaa.image = UIImage(named: "上のやつ")
        happa.image = UIImage(named: "葉っぱ")
        
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)
        
        
        //UD.set(pastDay1, forKey: "today")
        judgeDate()
        userDefaults1.register(defaults: ["tryCount" : 0])
        
        if tryCount >= 1{
            userDefaults1.set(tryCount, forKey: "tryCount")
        }
        tryCount = userDefaults1.object(forKey: "tryCount") as! Int
        
        Time.text = String(tryCount)
            
       userDefaults1.register(defaults: ["expPoint2" : 0])
        
        if expPoint2 >= 1{
        userDefaults1.set(expPoint2, forKey: "expPoint2")
        }
        
        expPoint2 = userDefaults1.object(forKey: "expPoint2") as! Int
        
        levelJudge()
    
        
        exppp.text = String(level)
        
        
        
        userDefaults1.register(defaults: ["rankNumber" : 0])
        if rankNumber >= 1{
            userDefaults1.set(rankNumber, forKey: "rankNumber")
        }else{
            userDefaults1.set(0, forKey: "rankNumber")
        }
        rankNumber = userDefaults1.object(forKey: "rankNumber") as! Int
        
       rank.text = rankName[rankNumber]
        
        

        // Do any additional setup after loading the view.
    }
    
    func levelJudge() {
        for i in 2..<100{
            if exp[i] > expPoint2{
               level = i-1
               return
            }
        }
    }
    
    @IBAction func toQustion(_ sender: UIButton) {
        music(sound: "button")
        performSegue(withIdentifier: "toQuestion1", sender: word)
    }
    
    @IBAction func toQuestion2(_ sender: UIButton) {
        music(sound: "button")
         performSegue(withIdentifier: "toQuestion2", sender: sentence)
    }
    
    @IBAction func toQuestion3(_ sender: UIButton) {
        music(sound: "button")
        performSegue(withIdentifier: "toQuestion3", sender: English)
    }
    
    @IBAction func toQuestion4(_ sender: UIButton) {
        music(sound: "button")
        performSegue(withIdentifier: "toQuestion4", sender: anki)
    }
    
    @IBAction func toBeforeTry(_ sender: UIButton) {
        judgeDate()
        if tryCount <= 2 {
            music(sound: "button")
            performSegue(withIdentifier: "toBeforeTry", sender: toTry)
        }else{
            let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "昇段試験は1日3回までです。", preferredStyle:  UIAlertController.Style.alert)
            
                        let defaultAction: UIAlertAction = UIAlertAction(title: "制限解除", style: UIAlertAction.Style.default, handler:{
            
                            (action: UIAlertAction!) -> Void in
                            print("OK")
                        })
            
                        let cancelAction: UIAlertAction = UIAlertAction(title: "戻る", style: UIAlertAction.Style.cancel, handler: {
                            (action: UIAlertAction!) -> Void in
                            print("Cancel")
                        })
            
                        alert.addAction(cancelAction)
                        alert.addAction(defaultAction)
            
                        present(alert, animated: true, completion:  nil)
            
    }
    }
    
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toQuestion1"{
                let nextView = segue.destination as! ViewController
                nextView.choice = 0
            }
            if segue.identifier == "toQuestion2"{
                let nextView = segue.destination as! ViewController
                nextView.choice = 1
            }
            if segue.identifier == "toQuestion3"{
            let nextView = segue.destination as! ViewController
            nextView.choice = 2
            }
            if segue.identifier == "toQuestion4"{
                let nextView = segue.destination as! ViewController
                nextView.choice = 3
                
            }
            if segue.identifier == "toBeforeTry"{
                let beforeTryView = segue.destination as! BeforeTry
                beforeTryView.rankNum = rankNumber
                beforeTryView.tryCount = tryCount
            }
            
}
    func judgeDate(){
       

        
            let pastDay = UD.object(forKey: "today") as! Date
            let now = calendar.component(.day, from: nowDay)
            let past = calendar.component(.day, from: pastDay)

            //日にちが変わっていた場合
            if now != past {
                judge = true
                UD.set(nowDay, forKey: "today")
            }
       

        if judge == true{
            tryCount = 0
            userDefaults1.set(tryCount, forKey: "tryCount")
            Time.text = String(tryCount)
            judge = false
        }

    }

    @IBAction func minus(_ sender: Any) {
        tryCount -= 1
        Time.text = String(tryCount)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

