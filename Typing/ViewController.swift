//
//  ViewController.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/04/27.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AudioToolbox
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var good: UILabel!
    @IBOutlet weak var coun: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var backHome: UIButton!
    @IBOutlet weak var retry: UIButton!
    @IBOutlet weak var shiji: UILabel!
    @IBOutlet weak var flower: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var jouro: UIImageView!
    
    
    
    
    
    
    var question = ""
    var ans1 = ""
    var ans2 = ""
    var count = 0
    var abc = true
    var quesCount = 0
    var myTimer: Timer!
    var myTimer2: Timer!
    var usedTime1 :Double = 0
    var letterCount = 0
    var record:[Double] = [0,0,0]
    var lpm:Double = 0
    var choice:Int = 0
    var stop = false
    var started = false
    var animation = true
    var finish = false
    var expPoint = 0
    let kind = ["word","sentence","English","anki"]
    let userDefaults = UserDefaults.standard
    let qNum = [10,5,10,10]
    var flowers = 0
    var audioPlayer: AVAudioPlayer!
    var bgmPlayer: AVAudioPlayer!
    var bgm = 0

    var timerr: [Int] = [30,0,0]
    var timerr2:Double = 0.1
    @IBOutlet weak var time: UILabel!
    
    
    
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
    
    func bgmmusic(sound: String) {
        let audioPath = Bundle.main.path(forResource: sound, ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        var audioError:NSError?
           do {
               bgmPlayer = try AVAudioPlayer(contentsOf: audioUrl)
           } catch let error as NSError {
               audioError = error
               bgmPlayer = nil
           }
           if let error = audioError {
                          print("Error")
                      }
           bgmPlayer.delegate = self
                      bgmPlayer.prepareToPlay()
        bgmPlayer.play()
    }
    
    
   func shortVibrate() {
       AudioServicesPlaySystemSound(1003);
       AudioServicesDisposeSystemSoundID(1003);
   }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         // Do any additional setup after loading the view.
         bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
         bannerView.rootViewController = self
         bannerView.load(GADRequest())
        
         self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)
         flower.image = UIImage(named: "花1")
         shiji.text = "タップしてスタート"
         shiji.isHidden = false
         Random()
         aaa()
         count = 0
         questionLabel.text = question
         ansLabel.text = ans1
         retry.setTitle("Retry", for: .normal)
         
         time.text = String(timerr[0])+":"+String(timerr[1])+String(timerr[2])
         
       
         userDefaults.register(defaults: ["word": [0,0,0]])
                
         userDefaults.register(defaults: ["sentence": [0,0,0]])
                
         userDefaults.register(defaults: ["English": [0,0,0]])
         
         userDefaults.register(defaults: ["anki": [0,0,0]])
         
           record = userDefaults.object(forKey: kind[choice]) as! [Double]
         
         userDefaults.register(defaults:["expPoint" : 0])
                
         
     }
    
     
     @objc func timer(){
         
         if (timerr[0] == 0 && timerr[1] == 0 && timerr[2] == 0) {
             finish = true
             myTimer.invalidate()
             bgmPlayer.stop()
             
             performSegue(withIdentifier: "toSecond", sender: nil)
             
         } else {
             if timerr[2] > 0 {
                 //秒数が0以上の時秒数を-1
                 timerr[2] -= 1
             } else {
                 //秒数が0の時
                 timerr[2] += 9
                 if timerr[1] > 0 {
                     //分が0以上の時、分を-1
                     timerr[1] -= 1
                 } else {
                     //分が０の時、+59分、時間-1
                     timerr[1] += 9
                     timerr[0] -= 1
                 }
             }
             time.text = String(timerr[0]) + ":" + String(timerr[1])+String(timerr[2])
         }

         
     }
     
     @objc func timer2(){
         timerr2 += 0.1
         
         if (timerr2 >= 1){
             myTimer2.invalidate()
             questionLabel.text = ""
             timerr2 = 0
         }
     }
     
    

     @IBAction func EditingDidBegin(_ sender: Any) {
         myTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:#selector(timer) , userInfo: nil, repeats: true)
         started = true
         stop = true
         retry.setTitle("Stop", for: .normal)
         shiji.isHidden = true
        if bgm == 0 {
            bgm += 1
            bgmmusic(sound: "草原の小鳥")
        } else{
            bgmPlayer.play()
        }
         
         if(choice == 3){
             myTimer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(timer2) , userInfo: nil, repeats: true)
         }
         UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat], animations: {
                    self.jouro.transform = CGAffineTransform(rotationAngle: CGFloat.pi/10)
                }, completion: nil)
                
                if animation == false {
                    resumeLayer(layer: jouro.layer)
                    animation = true
                }
         
         
     }
     

     @IBAction func EditingChanged(_ sender: Any) {
         judge()
         misJudge()
         
         
     }
     
     func aaa(){
         coun.text = String(count)
     }
     
     func pauseLayer(layer: CALayer) {
      let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
         layer.speed = 0.0
         layer.timeOffset = pausedTime
     }

     func resumeLayer(layer: CALayer) {
         let pausedTime: CFTimeInterval = layer.timeOffset
         layer.speed = 1.0
         layer.timeOffset = 0.0
         layer.beginTime = 0.0
      let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
         layer.beginTime = timeSincePause
     }

     
     @IBAction func retryyy(_ sender: Any) {
         music(sound: "button")
         if started == false{
             count = 0
             abc = true
             quesCount = 0
             usedTime1 = 0
             letterCount = 0
             timerr = [30,0,0]
             stop = false
             
             
             self.loadView()
             self.viewDidLoad()
         }
         if started == true && stop == true{
             myTimer.invalidate()
             bgmPlayer.pause()
             animation = false
             stop = false
             retry.setTitle("Retry", for: .normal)
             field.endEditing(true)
             shiji.text = "タップして再開"
             shiji.isHidden = false
             pauseLayer(layer: jouro.layer)
             
         }else if started == true && stop == false{
             count = 0
             abc = true
             quesCount = 0
             usedTime1 = 0
             letterCount = 0
             timerr = [30,0,0]
             stop = false
             
             
             self.loadView()
             self.viewDidLoad()
         }
         
     }
     
     func judge(){
        
         
     if quesCount < qNum[choice]-1 {
         if field.text! == ans1{
             music(sound: "パッ")
             field.text = ""
             quesCount += 1
             letterCount += question.count
             
             if (choice == 3){
              myTimer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(timer2) , userInfo: nil, repeats: true)
             }
             changeFlowers(index: quesCount)
             Random()
             questionLabel.text = question
             ansLabel.text = ans1
             
         }else if field.text! == ans1.prefix(field.text!.count){
             
            ansLabel.text = String(ans1.suffix(ans1.count-field.text!.count))
             
             
             
           }
         }else{
             if field.text! == ans1{
                 
                 field.text = ""
                 ansLabel.text = ""
                 quesCount = 0
                 letterCount += question.count
                 flowers = 4
                 bgm = 0
                 bgmPlayer.stop()
                 myTimer.invalidate()
                 
                 
                 usedTime1 = 30 - Double(timerr[0]) - Double(timerr[1])/10 - Double(timerr[2])/100
                 
               
                 
                   lpm = round(60*Double(letterCount)/usedTime1)
                 
                 
                 if lpm >= record[0]{
                     record[2] = record[1]
                     record[1] = record[0]
                     record[0] = lpm
                 }else if lpm >= record[1]{
                     record[2] = record[1]
                     record[1] = lpm
                 }else if lpm >= record[2]{
                     record[2] = lpm
                 }
                 
                 SaveData(hairetsu:record,sort:kind[choice])
                 
                 expPoint =  userDefaults.object(forKey: "expPoint") as! Int
                 if choice == 0 {
                 expPoint += 1
                 }else{
                  expPoint += 2
                 }
                 
                 SaveExp(point: expPoint)
                 
                 let vc = self.presentingViewController as! Top
                 
                 vc.expPoint2 = userDefaults.object(forKey: "expPoint") as! Int
                 vc.viewDidLoad()
                 
                 
                 
                  performSegue(withIdentifier: "toSecond", sender: nil)
                 
             }else if field.text! == ans1.prefix(field.text!.count){
              
             ansLabel.text = String(ans1.suffix(ans1.count-field.text!.count))
             
              
              
             }
         }//else
         
     }//judge
     
     func misJudge(){
         if field.text != "" {
         
             if ans2.count >= 2{
         
                     if field.text!.suffix(1) == ans2.prefix(1){
                         ans2 = String(ans2.suffix(ans2.count - 1))
                         good.text = ans2
                         abc = true
                         }
                         
                     else if abc == true && field.text!.suffix(1) != ans2.prefix(1){
                         count += 1
                         aaa()
                         abc = false
                         shortVibrate()
                         
                         }
         
         
             }else if field.text!.suffix(1) != ans2  && abc == true{
                     abc = false
                     count += 1
                     shortVibrate()
                     aaa()
             }else if field.text!.suffix(1) == ans2{
                 abc = true
                 }
         
         }
         
     }
     
     func SaveData(hairetsu:[Double],sort:String){
            userDefaults.set(hairetsu, forKey: sort)
        }
     
     func SaveExp(point:Int){
         userDefaults.set(point, forKey: "expPoint")
     }
     
     
     
     @IBAction func back(_ sender: Any) {
         music(sound: "button")
         if bgm != 0{
            bgmPlayer.stop()
         }
        if stop == true{
            myTimer.invalidate()
        }
         dismiss(animated: true, completion: nil)
        
        
         
     }
     
     func textFieldShouldReturn(field: UITextField) -> Bool{
         field.resignFirstResponder()
         return true
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                 if segue.identifier == "toSecond"{
                     let second = segue.destination as! SecondViewController
                     second.misss = String(count)
                     second.usedTimee  = usedTime1
                     second.rrrecorddd =  record
                     second.letterCount2 = Double(letterCount)
                     second.time = finish
                     second.flowers = flowers
                    
                 
     }
     
     }
     
     
     func changeFlowers(index: Int) {
         if index >= qNum[choice]/4 {
             flower.image = UIImage(named: "花2")
             flowers = 1
         }
         if index >= qNum[choice]/2 {
             flower.image = UIImage(named: "花3")
             flowers = 2
         }
         if index >= 3*qNum[choice]/4 {
             flower.image = UIImage(named: "花4")
             flowers = 3
         }
     }

     
        func Random(){
            var randomNumber = Int.random(in: 1..<100)
               if choice == 0{
                  switch (randomNumber) {
                  case 1:
                      question = "ノート"
                      ans1 = "のーと"
                      ans2 = "のーと"
                      
                      break
                  case 2:
                      question = "スマホ"
                      ans1 = "すまほ"
                      ans2 = "すまほ"
                      
                      break
                  case 3:
                      question = "検索"
                      ans1 = "けんさく"
                      ans2 = "けんさく"
                      break
                  case 4:
                      question = "携帯"
                      ans1 = "けいたい"
                      ans2 = "けいたい"
                      
                      break
                  case 5:
                      question = "風情"
                      ans1 = "ふぜい"
                      ans2 = "ふせぜい"
                      
                      break
                  case 6:
                      question = "便利"
                      ans1 = "べんり"
                      ans2 = "へべんり"
                      break
                  case 7:
                      question = "主催"
                      ans1 = "しゅさい"
                      ans2 = "しゆゅさい"
                        
                      break
                  case 8:
                      question = "レベル"
                      ans1 = "れべる"
                      ans2 = "れへべる"
                        
                      break
                  case 9:
                      question = "洗濯"
                      ans1 = "せんたく"
                      ans2 = "せんたく"
                      break
                    
                    case 10:
                        question = "睡眠"
                        ans1 = "すいみん"
                        ans2 = "すいみん"
                        
                        break
                    case 11:
                        question = "料理"
                        ans1 = "りょうり"
                        ans2 = "りよょうり"
                        
                        break
                    case 12:
                        question = "走る"
                        ans1 = "はしる"
                        ans2 = "はしる"
                        break
                    case 13:
                        question = "フリーダイヤル"
                        ans1 = "ふりーだいやる"
                        ans2 = "ふりーただいやる"
                        
                        break
                    case 14:
                        question = "ライバル"
                        ans1 = "らいばる"
                        ans2 = "らいはばる"
                        
                        break
                    case 15:
                        question = "美しい"
                        ans1 = "うつくしい"
                        ans2 = "うつくしい"
                        break
                    case 16:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 17:
                        question = "物流"
                        ans1 = "ぶつりゅう"
                        ans2 = "ふぶつりゆゅう"
                          
                        break
                    case 18:
                        question = "尊敬"
                        ans1 = "そんけい"
                        ans2 = "そんけい"
                        break
                    case 19:
                        question = "合併"
                        ans1 = "がっぺい"
                        ans2 = "かがつっへぺい"
                        
                        break
                    case 20:
                        question = "著作権"
                        ans1 = "ちょさくけん"
                        ans2 = "ちよょさくけん"
                        
                        break
                    case 21:
                        question = "代理店"
                        ans1 = "だいりてん"
                        ans2 = "ただいりてん"
                        break
                    case 22:
                        question = "格付け"
                        ans1 = "かくづけ"
                        ans2 = "かくつづけ"
                        
                        break
                    case 23:
                        question = "栄養"
                        ans1 = "えいよう"
                        ans2 = "えいよう"
                        
                        break
                    case 24:
                        question = "評論家"
                        ans1 = "ひょうろんか"
                        ans2 = "ひよょうろんか"
                        break
                    case 25:
                        question = "サークル"
                        ans1 = "さーくる"
                        ans2 = "さーくる"
                          
                        break
                    case 26:
                        question = "破産"
                        ans1 = "はさん"
                        ans2 = "はさん"
                          
                        break
                    case 27:
                        question = "偏見"
                        ans1 = "へんけん"
                        ans2 = "へんけん"
                        break
                    case 28:
                        question = "リマインド"
                        ans1 = "りまいんど"
                        ans2 = "りまいんど"
                        
                        break
                    case 29:
                        question = "打ち合わせ"
                        ans1 = "うちあわせ"
                        ans2 = "うちあわせ"
                        
                        break
                    case 30:
                        question = "ミーティング"
                        ans1 = "みーてぃんぐ"
                        ans2 = "みーていぃんくぐ"
                        break
                    case 31:
                        question = "服装"
                        ans1 = "ふくそう"
                        ans2 = "ふくそう"
                        
                        break
                    case 32:
                        question = "説明"
                        ans1 = "せつめい"
                        ans2 = "せつめい"
                        
                        break
                    case 33:
                        question = "責任"
                        ans1 = "せきにん"
                        ans2 = "せきにん"
                        break
                    case 34:
                        question = "ケンカ"
                        ans1 = "けんか"
                        ans2 = "けんか"
                          
                        break
                    case 35:
                        question = "ビジネス"
                        ans1 = "びじねす"
                        ans2 = "ひびしじねす"
                          
                        break
                    case 36:
                        question = "石油"
                        ans1 = "せきゆ"
                        ans2 = "せきゆ"
                        break
                    case 37:
                        question = "リスク"
                        ans1 = "りすく"
                        ans2 = "りすく"
                        
                        break
                    case 38:
                        question = "リターン"
                        ans1 = "りたーん"
                        ans2 = "りたーん"
                        
                        break
                    case 39:
                        question = "飲み会"
                        ans1 = "のみかい"
                        ans2 = "のみかい"
                        break
                    case 40:
                        question = "日除け"
                        ans1 = "ひよけ"
                        ans2 = "ひよけ"
                        
                        break
                    case 41:
                        question = "ほのめかす"
                        ans1 = "ほのめかす"
                        ans2 = "ほのめかす"
                        
                        break
                    case 42:
                        question = "助ける"
                        ans1 = "たすける"
                        ans2 = "たすける"
                        break
                    case 43:
                        question = "企画する"
                        ans1 = "きかくする"
                        ans2 = "きかくする"
                          
                        break
                    case 44:
                        question = "思い出す"
                        ans1 = "おもいだす"
                        ans2 = "おもいただす"
                          
                        break
                    case 45:
                        question = "育てる"
                        ans1 = "そだてる"
                        ans2 = "そただてる"
                        break
                    case 46:
                        question = "驚く"
                        ans1 = "おどろく"
                        ans2 = "おとどろく"
                        
                        break
                    case 47:
                        question = "運転する"
                        ans1 = "うんてんする"
                        ans2 = "うんてんする"
                        
                        break
                    case 48:
                        question = "回復する"
                        ans1 = "かいふくする"
                        ans2 = "かいふくする"
                        break
                    case 49:
                        question = "切り出す"
                        ans1 = "きりだす"
                        ans2 = "きりただす"
                        
                        break
                    case 50:
                        question = "コピーする"
                        ans1 = "こぴーする"
                        ans2 = "こひぴーする"
                        
                        break
                    case 51:
                        question = "発生"
                        ans1 = "はっせい"
                        ans2 = "はつっせい"
                        break
                    case 52:
                        question = "割り当て"
                        ans1 = "わりあて"
                        ans2 = "わりあて"
                          
                        break
                    case 53:
                        question = "吹雪"
                        ans1 = "ふぶき"
                        ans2 = "ふふぶき"
                          
                        break
                    case 54:
                        question = "国勢調査"
                        ans1 = "こくせいちょうさ"
                        ans2 = "こくせいちよょうさ"
                        break
                    case 55:
                        question = "道具"
                        ans1 = "どうぐ"
                        ans2 = "とどうくぐ"
                        
                        break
                    case 56:
                        question = "計画"
                        ans1 = "けいかく"
                        ans2 = "けいかく"
                        
                        break
                    case 57:
                        question = "威嚇"
                        ans1 = "いかく"
                        ans2 = "いかく"
                        break
                    case 58:
                        question = "繰り返し"
                        ans1 = "くりかえし"
                        ans2 = "くりかえし"
                        
                        break
                    case 59:
                        question = "クリスマス"
                        ans1 = "くりすます"
                        ans2 = "くりすます"
                        
                        break
                    case 60:
                        question = "ハロウィン"
                        ans1 = "はろうぃん"
                        ans2 = "はろういぃん"
                        break
                    case 61:
                        question = "アフター"
                        ans1 = "あふたー"
                        ans2 = "あふたー"
                          
                        break
                    case 62:
                        question = "スウェット"
                        ans1 = "すうぇっと"
                        ans2 = "すうぅえぇつっと"
                          
                        break
                    case 63:
                        question = "オープン"
                        ans1 = "おーぷん"
                        ans2 = "おーふぷん"
                        break
                    case 64:
                        question = "オリエンテーション"
                        ans1 = "おりえんてーしょん"
                        ans2 = "おりえんてーしよょん"
                        
                        break
                    case 65:
                        question = "ラスト"
                        ans1 = "らすと"
                        ans2 = "らすと"
                        
                        break
                    case 66:
                        question = "コンパ"
                        ans1 = "こんぱ"
                        ans2 = "こんはぱ"
                        break
                    case 67:
                        question = "合宿"
                        ans1 = "がっしゅく"
                        ans2 = "かがつっしゆゅく"
                        
                        break
                    case 68:
                        question = "テニス"
                        ans1 = "てにす"
                        ans2 = "てにす"
                        
                        break
                    case 69:
                        question = "野球"
                        ans1 = "やきゅう"
                        ans2 = "やきゆゅう"
                        break
                    case 70:
                        question = "サッカー"
                        ans1 = "さっかー"
                        ans2 = "さつっかー"
                          
                        break
                    case 71:
                        question = "アットホーム"
                        ans1 = "あっとほーむ"
                        ans2 = "あつっとほーむ"
                          
                        break
                    case 72:
                        question = "アドバイス"
                        ans1 = "あどばいす"
                        ans2 = "あとどはばいす"
                        break
                    case 73:
                        question = "ダウンタウン"
                        ans1 = "だうんたうん"
                        ans2 = "ただうんたうん"
                        
                        break
                    case 74:
                        question = "テレビ"
                        ans1 = "てれび"
                        ans2 = "てれひび"
                        
                        break
                    case 75:
                        question = "バスケ"
                        ans1 = "ばすけ"
                        ans2 = "はばすけ"
                        break
                    case 76:
                        question = "バドミントン"
                        ans1 = "ばどみんとん"
                        ans2 = "はばとどみんとん"
                        
                        break
                    case 77:
                        question = "陸上"
                        ans1 = "りくじょう"
                        ans2 = "りくしじよょう"
                        
                        break
                    case 78:
                        question = "フレッシュ"
                        ans1 = "ふれっしゅ"
                        ans2 = "ふれつっしゆゅ"
                        break
                    case 79:
                        question = "総理大臣"
                        ans1 = "そうりだいじん"
                        ans2 = "そうりただいしじん"
                          
                        break
                    case 80:
                        question = "契約"
                        ans1 = "けいやく"
                        ans2 = "けいやく"
                          
                        break
                    case 81:
                        question = "数学"
                        ans1 = "すうがく"
                        ans2 = "すうかがく"
                        break
                    case 82:
                        question = "金曜日"
                        ans1 = "きんようび"
                        ans2 = "きんようひび"
                        
                        break
                    case 83:
                        question = "先輩"
                        ans1 = "せんぱい"
                        ans2 = "せんはぱい"
                        
                        break
                    case 84:
                        question = "タイピング"
                        ans1 = "たいぴんぐ"
                        ans2 = "たいひぴんくぐ"
                        break
                    case 85:
                        question = "フリック"
                        ans1 = "ふりっく"
                        ans2 = "ふりつっく"
                        
                        break
                    case 86:
                        question = "リラックス"
                        ans1 = "りらっくす"
                        ans2 = "りらつっくす"
                        
                        break
                    case 87:
                        question = "ズーム"
                        ans1 = "ずーむ"
                        ans2 = "すずーむ"
                        break
                    case 88:
                        question = "イベント"
                        ans1 = "いべんと"
                        ans2 = "いへべんと"
                          
                        break
                    case 89:
                        question = "結婚"
                        ans1 = "けっこん"
                        ans2 = "けつっこん"
                          
                        break
                    case 90:
                        question = "見つける"
                        ans1 = "みつける"
                        ans2 = "みつける"
                        break
                    case 91:
                        question = "アマゾン"
                        ans1 = "あまぞん"
                        ans2 = "あまそぞん"
                        break
                    case 92:
                        question = "オンライン"
                        ans1 = "おんらいん"
                        ans2 = "おんらいん"
                        
                        break
                    case 93:
                        question = "点数"
                        ans1 = "てんすう"
                        ans2 = "てんすう"
                        
                        break
                    case 94:
                        question = "英会話"
                        ans1 = "えいかいわ"
                        ans2 = "えいかいわ"
                        break
                    case 95:
                        question = "昇段"
                        ans1 = "しょうだん"
                        ans2 = "しよょうただん"
                        
                        break
                    case 96:
                        question = "段位"
                        ans1 = "だんい"
                        ans2 = "ただんい"
                        
                        break
                    case 97:
                        question = "寝巻き"
                        ans1 = "ねまき"
                        ans2 = "ねまき"
                        break
                    case 98:
                        question = "消臭剤"
                        ans1 = "しょうしゅうざい"
                        ans2 = "しよょうしゆゅうさざい"
                          
                        break
                    case 99:
                        question = "降段"
                        ans1 = "こうだん"
                        ans2 = "こうただん"
                          
                        break
                  default:
                    question = "アプリ"
                    ans1 = "あぷり"
                    ans2 = "あふぷり"
                    break
                }
               }
               
               
               if choice == 1{
                  switch (randomNumber) {
                  case 1:
                      question = "夏合宿"
                      ans1 = "なつがっしゅく"
                      ans2 = "なつかがつっしゆゅく"
                      //person = "夏目"
                      
                      
                      break
                  case 2:
                      question = "海岸"
                      ans1 = "かいがん"
                      ans2 = "かいかがん"
                      break
                  case 3:
                      question = "差別"
                      ans1 = "さべつ"
                      ans2 = "さへべつ"
                      break
                  default:
                      question = "次第"
                      ans1 = "しだい"
                      ans2 = "しただい"
                      break
                  }
               }
               
               if choice == 2{
                  switch (randomNumber) {
                  case 1:
                      question = "pay"
                      ans1 = "pay"
                      ans2 = "pay"
                      
                      break
                  case 2:
                      question = "what"
                      ans1 = "what"
                      ans2 = "what"
                      
                      break
                  case 3:
                      question = "exchange"
                      ans1 = "exchange"
                      ans2 = "exchange"
                      break
                  case 4:
                      question = "credit"
                      ans1 = "credit"
                      ans2 = "credit"
                      
                      break
                  case 5:
                      question = "problem"
                      ans1 = "problem"
                      ans2 = "problem"
                      
                      break
                  case 6:
                      question = "check"
                      ans1 = "check"
                      ans2 = "check"
                      break
                  case 7:
                      question = "plan"
                      ans1 = "plan"
                      ans2 = "plan"
                        
                      break
                  case 8:
                      question = "error"
                      ans1 = "error"
                      ans2 = "error"
                        
                      break
                  case 9:
                      question = "all"
                      ans1 = "all"
                      ans2 = "all"
                      break
                    
                    case 10:
                        question = "true"
                        ans1 = "true"
                        ans2 = "true"
                        
                        break
                    case 11:
                        question = "false"
                        ans1 = "false"
                        ans2 = "false"
                        
                        break
                    case 12:
                        question = "note"
                        ans1 = "note"
                        ans2 = "note"
                        break
                    case 13:
                        question = "best"
                        ans1 = "best"
                        ans2 = "best"
                        
                        break
                    case 14:
                        question = "word"
                        ans1 = "word"
                        ans2 = "word"
                        
                        break
                    case 15:
                        question = "buy"
                        ans1 = "buy"
                        ans2 = "buy"
                        break
                    case 16:
                        question = "run"
                        ans1 = "run"
                        ans2 = "run"
                          
                        break
                    case 17:
                        question = "second"
                        ans1 = "second"
                        ans2 = "second"
                          
                        break
                    case 18:
                        question = "soccer"
                        ans1 = "soccer"
                        ans2 = "soccer"
                        break
                    case 19:
                        question = "baseball"
                        ans1 = "baseball"
                        ans2 = "baseball"
                        
                        break
                    case 20:
                        question = "lemon"
                        ans1 = "lemon"
                        ans2 = "lemon"
                        
                        break
                    case 21:
                        question = "answer"
                        ans1 = "answer"
                        ans2 = "answer"
                        break
                    case 22:
                        question = "write"
                        ans1 = "write"
                        ans2 = "write"
                        
                        break
                    case 23:
                        question = "listen"
                        ans1 = "listen"
                        ans2 = "listen"
                        
                        break
                    case 24:
                        question = "cover"
                        ans1 = "cover"
                        ans2 = "cover"
                        break
                    case 25:
                        question = "which"
                        ans1 = "which"
                        ans2 = "which"
                          
                        break
                    case 26:
                        question = "why"
                        ans1 = "why"
                        ans2 = "why"
                          
                        break
                    case 27:
                        question = "how"
                        ans1 = "how"
                        ans2 = "how"
                        break
                    case 28:
                        question = "where"
                        ans1 = "where"
                        ans2 = "where"
                        
                        break
                    case 29:
                        question = "when"
                        ans1 = "when"
                        ans2 = "when"
                        
                        break
                    case 30:
                        question = "enjoy"
                        ans1 = "enjoy"
                        ans2 = "enjoy"
                        break
                    case 31:
                        question = "grow"
                        ans1 = "grow"
                        ans2 = "grow"
                        
                        break
                    case 32:
                        question = "logic"
                        ans1 = "logic"
                        ans2 = "logic"
                        
                        break
                    case 33:
                        question = "each"
                        ans1 = "each"
                        ans2 = "each"
                        break
                    case 34:
                        question = "other"
                        ans1 = "other"
                        ans2 = "other"
                          
                        break
                    case 35:
                        question = "people"
                        ans1 = "people"
                        ans2 = "people"
                          
                        break
                    case 36:
                        question = "return"
                        ans1 = "return"
                        ans2 = "return"
                        break
                    case 37:
                        question = "case"
                        ans1 = "case"
                        ans2 = "case"
                        
                        break
                    case 38:
                        question = "whether"
                        ans1 = "whether"
                        ans2 = "whether"
                        
                        break
                    case 39:
                        question = "with"
                        ans1 = "with"
                        ans2 = "with"
                        break
                    case 40:
                        question = "on"
                        ans1 = "on"
                        ans2 = "on"
                        
                        break
                    case 41:
                        question = "in"
                        ans1 = "in"
                        ans2 = "in"
                        
                        break
                    case 42:
                        question = "out"
                        ans1 = "out"
                        ans2 = "out"
                        break
                    case 43:
                        question = "from"
                        ans1 = "from"
                        ans2 = "from"
                          
                        break
                    case 44:
                        question = "food"
                        ans1 = "food"
                        ans2 = "food"
                          
                        break
                    case 45:
                        question = "drink"
                        ans1 = "drink"
                        ans2 = "drink"
                        break
                    case 46:
                        question = "they"
                        ans1 = "they"
                        ans2 = "they"
                        
                        break
                    case 47:
                        question = "opinion"
                        ans1 = "opinion"
                        ans2 = "opinion"
                        
                        break
                    case 48:
                        question = "question"
                        ans1 = "question"
                        ans2 = "question"
                        break
                    case 49:
                        question = "the"
                        ans1 = "the"
                        ans2 = "the"
                        
                        break
                    case 50:
                        question = "nature"
                        ans1 = "nature"
                        ans2 = "nature"
                        
                        break
                    case 51:
                        question = "near"
                        ans1 = "near"
                        ans2 = "near"
                        break
                    case 52:
                        question = "home"
                        ans1 = "home"
                        ans2 = "home"
                          
                        break
                    case 53:
                        question = "at"
                        ans1 = "at"
                        ans2 = "at"
                          
                        break
                    case 54:
                        question = "follow"
                        ans1 = "follow"
                        ans2 = "follow"
                        break
                    case 55:
                        question = "text"
                        ans1 = "text"
                        ans2 = "text"
                        
                        break
                    case 56:
                        question = "cream"
                        ans1 = "cream"
                        ans2 = "cream"
                        
                        break
                    case 57:
                        question = "sleep"
                        ans1 = "sleep"
                        ans2 = "sleep"
                        break
                    case 58:
                        question = "make"
                        ans1 = "make"
                        ans2 = "make"
                        
                        break
                    case 59:
                        question = "read"
                        ans1 = "read"
                        ans2 = "read"
                        
                        break
                    case 60:
                        question = "speak"
                        ans1 = "speak"
                        ans2 = "speak"
                        break
                    case 61:
                        question = "paper"
                        ans1 = "paper"
                        ans2 = "paper"
                          
                        break
                    case 62:
                        question = "test"
                        ans1 = "test"
                        ans2 = "test"
                          
                        break
                    case 63:
                        question = "another"
                        ans1 = "another"
                        ans2 = "another"
                        break
                    case 64:
                        question = "friend"
                        ans1 = "friend"
                        ans2 = "friend"
                        
                        break
                    case 65:
                        question = "girl"
                        ans1 = "girl"
                        ans2 = "girl"
                        
                        break
                    case 66:
                        question = "boy"
                        ans1 = "boy"
                        ans2 = "boy"
                        break
                    case 67:
                        question = "kind"
                        ans1 = "kind"
                        ans2 = "kind"
                        
                        break
                    case 68:
                        question = "product"
                        ans1 = "product"
                        ans2 = "product"
                        
                        break
                    case 69:
                        question = "frame"
                        ans1 = "frame"
                        ans2 = "frame"
                        break
                    case 70:
                        question = "tree"
                        ans1 = "tree"
                        ans2 = "tree"
                          
                        break
                    case 71:
                        question = "before"
                        ans1 = "before"
                        ans2 = "before"
                          
                        break
                    case 72:
                        question = "after"
                        ans1 = "after"
                        ans2 = "after"
                        break
                    case 73:
                        question = "try"
                        ans1 = "try"
                        ans2 = "try"
                        
                        break
                    case 74:
                        question = "result"
                        ans1 = "result"
                        ans2 = "result"
                        
                        break
                    case 75:
                        question = "main"
                        ans1 = "main"
                        ans2 = "main"
                        break
                    case 76:
                        question = "story"
                        ans1 = "story"
                        ans2 = "story"
                        
                        break
                    case 77:
                        question = "view"
                        ans1 = "view"
                        ans2 = "view"
                        
                        break
                    case 78:
                        question = "vision"
                        ans1 = "vision"
                        ans2 = "vision"
                        break
                    case 79:
                        question = "break"
                        ans1 = "break"
                        ans2 = "break"
                          
                        break
                    case 80:
                        question = "computer"
                        ans1 = "computer"
                        ans2 = "computer"
                          
                        break
                    case 81:
                        question = "weak"
                        ans1 = "weak"
                        ans2 = "weak"
                        break
                    case 82:
                        question = "strong"
                        ans1 = "strong"
                        ans2 = "strong"
                        
                        break
                    case 83:
                        question = "it"
                        ans1 = "it"
                        ans2 = "it"
                        
                        break
                    case 84:
                        question = "was"
                        ans1 = "was"
                        ans2 = "was"
                        break
                    case 85:
                        question = "were"
                        ans1 = "were"
                        ans2 = "were"
                        
                        break
                    case 86:
                        question = "that"
                        ans1 = "that"
                        ans2 = "that"
                        
                        break
                    case 87:
                        question = "this"
                        ans1 = "this"
                        ans2 = "this"
                        break
                    case 88:
                        question = "school"
                        ans1 = "school"
                        ans2 = "school"
                          
                        break
                    case 89:
                        question = "teacher"
                        ans1 = "teacher"
                        ans2 = "teacher"
                          
                        break
                    case 90:
                        question = "level"
                        ans1 = "level"
                        ans2 = "level"
                        break
                    case 91:
                        question = "rank"
                        ans1 = "rank"
                        ans2 = "rank"
                        break
                    case 92:
                        question = "should"
                        ans1 = "should"
                        ans2 = "should"
                        
                        break
                    case 93:
                        question = "me"
                        ans1 = "me"
                        ans2 = "me"
                        
                        break
                    case 94:
                        question = "love"
                        ans1 = "love"
                        ans2 = "love"
                        break
                    case 95:
                        question = "you"
                        ans1 = "you"
                        ans2 = "you"
                        
                        break
                    case 96:
                        question = "human"
                        ans1 = "human"
                        ans2 = "human"
                        
                        break
                    case 97:
                        question = "for"
                        ans1 = "for"
                        ans2 = "for"
                        break
                    case 98:
                        question = "music"
                        ans1 = "music"
                        ans2 = "music"
                          
                        break
                    case 99:
                        question = "talk"
                        ans1 = "talk"
                        ans2 = "talk"
                          
                        break
                  default:
                    question = "and"
                    ans1 = "and"
                    ans2 = "and"
                    break
                  }
               }
               if choice == 3{
                  switch (randomNumber) {
                  case 1:
                      question = ""
                      ans1 = ""
                      ans2 = ""
                      
                      break
                  case 2:
                      question = ""
                      ans1 = ""
                      ans2 = ""
                      
                      break
                  case 3:
                      question = ""
                      ans1 = ""
                      ans2 = ""
                      break
                  case 4:
                      question = ""
                      ans1 = ""
                      ans2 = ""
                      
                      break
                  case 5:
                      question = ""
                      ans1 = ""
                      ans2 = ""
                      
                      break
                  case 6:
                      question = ""
                      ans1 = ""
                      ans2 = ""
                      break
                  case 7:
                      question = ""
                      ans1 = ""
                      ans2 = ""
                        
                      break
                  case 8:
                      question = ""
                      ans1 = ""
                      ans2 = ""
                        
                      break
                  case 9:
                      question = ""
                      ans1 = ""
                      ans2 = ""
                      break
                    
                    case 10:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 11:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 12:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 13:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 14:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 15:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 16:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 17:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 18:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 19:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 20:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 21:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 22:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 23:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 24:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 25:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 26:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 27:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 28:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 29:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 30:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 31:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 32:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 33:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 34:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 35:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 36:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 37:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 38:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 39:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 40:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 41:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 42:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 43:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 44:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 45:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 46:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 47:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 48:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 49:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 50:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 51:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 52:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 53:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 54:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 55:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 56:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 57:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 58:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 59:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 60:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 61:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 62:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 63:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 64:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 65:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 66:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 67:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 68:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 69:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 70:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 71:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 72:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 73:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 74:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 75:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 76:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 77:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 78:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 79:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 80:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 81:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 82:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 83:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 84:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 85:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 86:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 87:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 88:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 89:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 90:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 91:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 92:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 93:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 94:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 95:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 96:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        
                        break
                    case 97:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                        break
                    case 98:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                    case 99:
                        question = ""
                        ans1 = ""
                        ans2 = ""
                          
                        break
                  default:
                    question = ""
                    ans1 = ""
                    ans2 = ""
                    break
                  }
               }
               
               
                  


}
}
