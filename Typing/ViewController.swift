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
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var backHome: UIButton!
    @IBOutlet weak var retry: UIButton!
    @IBOutlet weak var shiji: UILabel!
    @IBOutlet weak var flower: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var jouro: UIImageView!
    @IBOutlet weak var counting: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var personView: UIImageView!
    
    
    
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
    var person = ""
    let tim:[Int] = [30,60,30,30]

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
         count = 0
         questionLabel.text = question
         ansLabel.text = ans1
         retry.setTitle("Retry", for: .normal)
        
         timerr[0] = tim[choice]
         
         time.text = String(timerr[0])+":"+String(timerr[1])+String(timerr[2])
         
       
         userDefaults.register(defaults: ["word": [0,0,0]])
                
         userDefaults.register(defaults: ["sentence": [0,0,0]])
                
         userDefaults.register(defaults: ["English": [0,0,0]])
         
         userDefaults.register(defaults: ["anki": [0,0,0]])
         
           record = userDefaults.object(forKey: kind[choice]) as! [Double]
         
         userDefaults.register(defaults:["expPoint" : 0])
        
        counting.text = "\(quesCount+1)/\(qNum[choice])"
        
        if choice != 1{
            personView.isHidden = true
        }
        
        personLabel.text = person
         
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
             timerr = [tim[choice],0,0]
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
             timerr = [tim[choice],0,0]
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
             letterCount += ans1.count
            counting.text = "\(quesCount+1)/\(qNum[choice])"
             
             if (choice == 3){
              myTimer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(timer2) , userInfo: nil, repeats: true)
             }
             changeFlowers(index: quesCount)
             Random()
             questionLabel.text = question
             ansLabel.text = ans1
             personLabel.text = person
             
         }else if field.text! == ans1.prefix(field.text!.count){
             
            ansLabel.text = String(ans1.suffix(ans1.count-field.text!.count))
             
             
             
           }
         }else{
             if field.text! == ans1{
                 
                 field.text = ""
                 ansLabel.text = ""
                 quesCount = 0
                 letterCount += ans1.count
                 flowers = 4
                 bgm = 0
                 bgmPlayer.stop()
                 myTimer.invalidate()
                 
                 
                 usedTime1 = Double(tim[choice]) - Double(timerr[0]) - Double(timerr[1])/10 - Double(timerr[2])/100
                 
               
                 
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
                if expPoint <= 949{
                    expPoint += 1
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
                         abc = true
                         }
                         
                     else if abc == true && field.text!.suffix(1) != ans2.prefix(1){
                         count += 1
                         abc = false
                         shortVibrate()
                         
                         }
         
         
             }else if field.text!.suffix(1) != ans2  && abc == true{
                     abc = false
                     count += 1
                     shortVibrate()
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
               if choice == 0{
                var randomNumber = Int.random(in: 1..<100)
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
                       question = "笑顔"
                       ans1 = "えがお"
                       ans2 = "えかがお"
                         
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
                       ans2 = "かがつっへべぺい"
                       
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
                       ans2 = "かくつっづけ"
                       
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
                       ans2 = "りまいんとど"
                       
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
                       ans2 = "こひびぴーする"
                       
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
                ans2 = "すうえぇつっと"
                
                break
              case 63:
                question = "オープン"
                ans1 = "おーぷん"
                ans2 = "おーふぶぷん"
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
                ans2 = "こんはばぱ"
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
                ans2 = "せんはばぱい"
                
                break
              case 84:
                question = "タイピング"
                ans1 = "たいぴんぐ"
                ans2 = "たいひびぴんくぐ"
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
                ans1 = "ただんい"
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
                ans2 = "あふぶぷり"
                break
                }
                }
                
               if choice == 1{
                var randomNumber = Int.random(in: 1..<48)
                  switch (randomNumber) {
                    case 1:
                    question = "夢を見るから、人生は輝く"
                    ans1 = "ゆめをみるから、じんせいはかがやく"
                    ans2 = "ゆめをみるから、しじんせいはかかがやく"
                    person = "モーツァルト"
                    break

                    case 2:
                    question = "人を信じる心をなくしてはいけない"
                    ans1 = "ひとをしんじるこころをなくしてはいけない"
                    ans2 = "ひとをしんしじるこころをなくしてはいけない"
                    person = "ガンジー"
                    break

                    case 3:
                    question = "過ぎたことで心を煩わせるな"
                    ans1 = "すぎたことでこころをわずらわせるな"
                    ans2 = "すきぎたことてでこころをわすずらわせるな"
                    person = "ナポレオン"
                    break


                    case 4:
                    question = "平和は微笑みから始まります"
                    ans1 = "へいわはほほえみからはじまります"
                    ans2 = "へいわはほほえみからはしじまります"
                    person = "マザーテレサ"
                    break


                    case 5:
                    question = "急がずに、だが休まずに"
                    ans1 = "いそがずに、だがやすまずに"
                    ans2 = "いそかがすずに、ただかがやすますずに"
                    person = "ゲーテ"
                    break


                    case 6:
                    question = "全ては過程だ、結果ではない"
                    ans1 = "すべてはかていだ、けっかではない"
                    ans2 = "すへべてはかていただ、けつっかてではない"
                    person = "カール・ルイス"
                    break



                    case 7:
                    question = "愛に触れると誰でも詩人になる"
                    ans1 = "あいにふれるとだれでもしじんになる"
                    ans2 = "あいにふれるとただれてでもししじんになる"
                    person = "プラトン"
                    break



                   case 8:
                   question = "負ける人のおかげで勝てるんだよな"
                   ans1 = "まけるひとのおかげでかてるんだよな"
                   ans2 = "まけるひとのおかけげてでかてるんただよな"
                   person = "相田みつを"
                    break




                    case 9:
                    question = "遠くへ放ち、さらにその先を想う"
                    ans1 = "とおくへはなち、さらにそのさきをおもう"
                    ans2 = "とおくへはなち、さらにそのさきをおもう"
                    person = "室伏広治"
                    break



                    case 10:
                    question = "走った距離は裏切らない"
                    ans1 = "はしったきょりはうらぎらない"
                    ans2 = "はしつったきよょりはうらきぎらない"
                    person = "野口みずき"
                    break



                    case 11:
                    question = "メンタルが変われば行動が変わる"
                    ans1 = "めんたるがかわればこうどうがかわる"
                    ans2 = "めんたるかがかわれはばこうとどうかがかわる"
                    person = "長友佑都"
                    break

                    case 12:
                    question = "俺は生きる伝説だ"
                    ans1 = "おれはいきるでんせつだ"
                    ans2 = "おれはいきるてでんせつただ"
                    person = "ウサイン・ボルト"
                    break


                    case 13:
                    question = "努力に逃げ道はない、努力を愛せ"
                    ans1 = "どりょくににげみちはない、どりょくをあいせ"
                    ans2 = "とどりよょくににけげみちはない、とどりよょくをあいせ"
                    person = "ロジャー・フェデラー"
                    break

                    case 14:
                    question = "慢心は人間の最大の敵だ"
                    ans1 = "まんしんはにんげんのさいだいのてきだ"
                    ans2 = "まんしんはにんけげんのさいただいのてきただ"
                    person = "シェイクスピア"
                    break


                    case 15:
                    question = "今日からお前は富士山だ！"
                    ans1 = "きょうからおまえはふじさんだ！"
                    ans2 = "きよょうからおまえはふしじさんただ！"
                    person = "松岡修造"
                    break


                    case 16:
                    question = "大迫半端ないって"
                    ans1 = "おおさこはんぱないって"
                    ans2 = "おおさこはんはばぱないつって"
                    person = "高校サッカー部員"
                    break


                    case 17:
                    question = "真犯人はこの中にいる！"
                    ans1 = "しんはんにんはこのなかにいる！"
                    ans2 = "しんはんにんはこのなかにいる！"
                    person = "金田一少年の事件簿"
                    break


                    case 18:
                    question = "見ろ、人がゴミのようだ"
                    ans1 = "みろ、ひとがごみのようだ"
                    ans2 = "みろ、ひとかがこごみのようただ"
                    person = "天空の城ラピュタ"
                    break


                    case 19:
                    question = "飛べねぇ豚はただの豚だ"
                    ans1 = "とべねぇぶたはただのぶただ"
                    ans2 = "とへべねえぇふぶたはたただのふぶたただ"
                    person = "紅の豚"
                    break


                    case 20:
                    question = "夢だけど、夢じゃなかった！"
                    ans1 = "ゆめだけど、ゆめじゃなかった！"
                    ans2 = "ゆめただけとど、ゆめしじやゃなかつった！"
                    person = "となりのトトロ"
                    break


                    case 21:
                    question = "諦めたらそこで試合終了ですよ"
                    ans1 = "あきらめたらそこでしあいしゅうりょうですよ"
                    ans2 = "あきらめたらそこてでしあいしゆゅうりよょうてですよ"
                    person = "スラムダンク"
                    break



                    case 22:
                    question = "愛してくれて、ありがとう！"
                    ans1 = "あいしてくれて、ありがとう！"
                    ans2 = "あいしてくれて、ありかがとう！"
                    person = "ONE PIECE"
                    break

                    case 23:
                    question = "医者はなんのためにあるんだ"
                    ans1 = "いしゃはなんのためにあるんだ"
                    ans2 = "いしやゃはなんのためにあるんただ"
                    person = "ブラック・ジャック"
                    break

                    case 24:
                    question = "俺の敵はだいたい俺です"
                    ans1 = "おれのてきはだいたいおれです"
                    ans2 = "おれのてきはただいたいおれてです"
                    person = "宇宙兄弟"
                    break


                    case 25:
                    question = "背中の傷は剣士の恥だ"
                    ans1 = "せなかのきずはけんしのはじだ"
                    ans2 = "せなかのきすずはけんしのはしじただ"
                    person = "ONE PIECE"
                    break


                    case 26:
                    question = "工藤新一、探偵さ"
                    ans1 = "くどうしんいち、たんていさ"
                    ans2 = "くとどうしんいち、たんていさ"
                    person = "名探偵コナン"
                    break



                    case 27:
                    question = "立て、立つんだジョー！"
                    ans1 = "たて、たつんだじょー！"
                    ans2 = "たて、たつんただしじよょー！"
                    person = "あしたのジョー"
                    break


                    case 28:
                    question = "フォースと共にあらんことを"
                    ans1 = "ふぉーすとともにあらんことを"
                    ans2 = "ふおぉーすとともにあらんことを"
                    person = "スター・ウォーズ"
                    break



                    case 29:
                    question = "やられたらやり返す、倍返しだ"
                    ans1 = "やられたらやりかえす、ばいがえしだ"
                    ans2 = "やられたらやりかえす、はばいかがえしただ"
                    person = "半沢直樹"
                    break


                    case 30:
                    question = "いつやるか、今でしょ"
                    ans1 = "いつやるか、いまでしょ"
                    ans2 = "いつやるか、いまてでしよょ"
                    person = "林修"
                    break


                    case 31:
                    question = "結果にコミットする"
                    ans1 = "けっかにこみっとする"
                    ans2 = "けつっかにこみつっとする"
                    person = "RIZAP"
                    break

                    case 32:
                    question = "こだまでしょうか、いいえ誰でも"
                    ans1 = "こだまでしょうか、いいえだれでも"
                    ans2 = "こただまてでしよょうか、いいえただれてでも"
                    person = "AC"
                    break

                    case 33:
                    question = "ペンパイナッポーアッポーペン"
                    ans1 = "ぺんぱいなっぽーあっぽーぺん"
                    ans2 = "へべぺんはばぱいなつっほぼぽーあつっほぼぽーへべぺん"
                    person = "ピコ太郎"
                    break

                    case 34:
                    question = "イェスウィーキャン！"
                    ans1 = "いぇすうぃーきゃん！"
                    ans2 = "いえぇすういぃーきやゃん！"
                    person = "バラク・オバマ"
                    break


                    case 35:
                    question = "宮崎をどげんかせんといかん"
                    ans1 = "みやざきをどげんかせんといかん"
                    ans2 = "みやさざきをとどけげんかせんといかん"
                    person = "東国原知事"
                    break


                    case 36:
                    question = "同情するなら金をくれ"
                    ans1 = "どうじょうするならかねをくれ"
                    ans2 = "とどうしじよょうするならかねをくれ"
                    person = "家なき子"
                    break

                    case 37:
                    question = "僕は死にましぇーん！"
                    ans1 = "ぼくはしにましぇーん！"
                    ans2 = "ほぼくはしにましえぇーん！"
                    person = "101回目のプロポーズ"
                    break

                    case 38:
                    question = "自由か、しからずんば死か"
                    ans1 = "じゆうか、しからずんばしか"
                    ans2 = "しじゆうか、しからすずんはばしか"
                    person = "パトリック・ヘンリー"
                    break
                    
                  case 39:
                      question = "地球は青かった"
                      ans1 = "ちきゅうはあおかった"
                      ans2 = "ちきゆゅうはあおかつった"
                      person = "ユーリイ・ガガーリン"
                        
                      break
                  case 40:
                      question = "赤信号みんなで渡れば怖くない"
                      ans1 = "あかしんごうみんなでわたればこわくない"
                      ans2 = "あかしんこごうみんなてでわたれはばこわくない"
                      person = "ビートたけし"
                      break
                  case 41:
                      question = "ちょっと何言ってるか分からない"
                      ans1 = "ちょっとなにいってるかわからない"
                      ans2 = "ちよょつっとなにいつってるかわからない"
                      person = "サンドウィッチマン"
                      
                      break
                  case 42:
                      question = "安心してください、履いてますよ"
                      ans1 = "あんしんしてください、はいてますよ"
                      ans2 = "あんしんしてくたださい、はいてますよ"
                      person = "とにかく明るい安村"
                      
                      break
                  case 43:
                      question = "右ひじ左ひじ交互に見て"
                      ans1 = "みぎひじひだりひじこうごにみて"
                      ans2 = "みきぎひしじひただりひしじこうこごにみて"
                      person = "2700"
                      break
                  case 44:
                      question = "始まりはどんなものでも小さい"
                      ans1 = "はじまりはどんなものでもちいさい"
                      ans2 = "はしじまりはとどんなものてでもちいさい"
                      person = "キケロ"
                      
                      break
                  case 45:
                      question = "吾輩は猫である、名前はまだない"
                      ans1 = "わがはいはねこである、なまえはまだない"
                      ans2 = "わかがはいはねこてである、なまえはまただない"
                      person = "吾輩は猫である"
                      
                      break
                  case 46:
                      question = "柿食えば鐘が鳴るなり法隆寺"
                      ans1 = "かきくえばかねがなるなりほうりゅうじ"
                      ans2 = "かきくえはばかねかがなるなりほうりゆゅうしじ"
                      person = "正岡子規"
                      break
                  default:
                      question = "古池や蛙飛び込む水の音"
                      ans1 = "ふるいけやかわずとびこむみずのおと"
                      ans2 = "ふるいけやかわすずとひびこむみすずのおと"
                      person = "松尾芭蕉"
                        
                      break
                }
            }
               
               if choice == 2{
                var randomNumber = Int.random(in: 1..<100)
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
                var randomNumber = Int.random(in: 1..<100)
                  switch (randomNumber) {
                  case 1:
                      question = "コンピューター"
                      ans1 = "こんぴゅーたー"
                      ans2 = "こんひびぴゆゅーたー"
                      
                      break
                  case 2:
                      question = "教科書"
                      ans1 = "きょうかしょ"
                      ans2 = "きよょうかしよょ"
                      
                      break
                  case 3:
                      question = "スマートフォン"
                      ans1 = "すまーとふぉん"
                      ans2 = "すまーとふおぉん"
                      break
                  case 4:
                      question = "単語帳"
                      ans1 = "たんごちょう"
                      ans2 = "たんこごちよょう"
                      
                      break
                  case 5:
                      question = "アルバイト"
                      ans1 = "あるばいと"
                      ans2 = "あるはばいと"
                      
                      break
                  case 6:
                      question = "アルコール"
                      ans1 = "あるこーる"
                      ans2 = "あるこーる"
                      break
                  case 7:
                      question = "写真"
                      ans1 = "しゃしん"
                      ans2 = "しやゃしん"
                        
                      break
                  case 8:
                      question = "カレンダー"
                      ans1 = "かれんだー"
                      ans2 = "かれんただー"
                        
                      break
                  case 9:
                      question = "ハンカチ"
                      ans1 = "はんかち"
                      ans2 = "はんかち"
                      break
                    
                    case 10:
                        question = "専門店"
                        ans1 = "せんもんてん"
                        ans2 = "せんもんてん"
                        
                        break
                    case 11:
                        question = "いい天気"
                        ans1 = "いいてんき"
                        ans2 = "いいてんき"
                        
                        break
                    case 12:
                        question = "こんにちは"
                        ans1 = "こんにちは"
                        ans2 = "こんにちは"
                        break
                    case 13:
                        question = "体調はいかがですか"
                        ans1 = "たいちょうはいかがですか"
                        ans2 = "たいちよょうはいかかがてですか"
                        
                        break
                    case 14:
                        question = "おはようございます"
                        ans1 = "おはようございます"
                        ans2 = "おはようこごさざいます"
                        
                        break
                    case 15:
                        question = "夏休み"
                        ans1 = "なつやすみ"
                        ans2 = "なつやすみ"
                        break
                    case 16:
                        question = "オンリーワン"
                        ans1 = "おんりーわん"
                        ans2 = "おんりーわん"
                          
                        break
                    case 17:
                        question = "料理をする"
                        ans1 = "りょうりをする"
                        ans2 = "りよょうりをする"
                          
                        break
                    case 18:
                        question = "感動する"
                        ans1 = "かんどうする"
                        ans2 = "かんとどうする"
                        break
                    case 19:
                        question = "精一杯"
                        ans1 = "せいいっぱい"
                        ans2 = "せいいつっはばぱい"
                        
                        break
                    case 20:
                        question = "漫画を読む"
                        ans1 = "まんがをよむ"
                        ans2 = "まんかがをよむ"
                        
                        break
                    case 21:
                        question = "トイレに行く"
                        ans1 = "といれにいく"
                        ans2 = "といれにいく"
                        break
                    case 22:
                        question = "数学"
                        ans1 = "すうがく"
                        ans2 = "すうかがく"
                        
                        break
                    case 23:
                        question = "趣味はテニスです"
                        ans1 = "しゅみはてにすです"
                        ans2 = "しゆゅみはてにすてです"
                        
                        break
                    case 24:
                        question = "買い物に行く"
                        ans1 = "かいものにいく"
                        ans2 = "かいものにいく"
                        break
                    case 25:
                        question = "活動を再開する"
                        ans1 = "かつどうをさいかいする"
                        ans2 = "かつとどうをさいかいする"
                          
                        break
                    case 26:
                        question = "予防する"
                        ans1 = "よぼうする"
                        ans2 = "よほぼうする"
                          
                        break
                    case 27:
                        question = "分析をする"
                        ans1 = "ぶんせきをする"
                        ans2 = "ふぶんせきをする"
                        break
                    case 28:
                        question = "好きな曲をきく"
                        ans1 = "すきなきょくをきく"
                        ans2 = "すきなきよょくをきく"
                        
                        break
                    case 29:
                        question = "映画を観る"
                        ans1 = "えいがをみる"
                        ans2 = "えいかがをみる"
                        
                        break
                    case 30:
                        question = "お茶を飲む"
                        ans1 = "おちゃをのむ"
                        ans2 = "おちやゃをのむ"
                        break
                    case 31:
                        question = "髪を乾かす"
                        ans1 = "かみをかわかす"
                        ans2 = "かみをかわかす"
                        
                        break
                    case 32:
                        question = "ダイエットする"
                        ans1 = "だいえっとする"
                        ans2 = "ただいえつっとする"
                        
                        break
                    case 33:
                        question = "ゲームをする"
                        ans1 = "げーむをする"
                        ans2 = "けげーむをする"
                        break
                    case 34:
                        question = "話し合いを行う"
                        ans1 = "はなしあいをおこなう"
                        ans2 = "はなしあいをおこなう"
                          
                        break
                    case 35:
                        question = "ノートを開く"
                        ans1 = "のーとをひらく"
                        ans2 = "のーとをひらく"
                          
                        break
                    case 36:
                        question = "携帯を落とす"
                        ans1 = "けいたいをおとす"
                        ans2 = "けいたいをおとす"
                        break
                    case 37:
                        question = "お腹がすいた"
                        ans1 = "おなかがすいた"
                        ans2 = "おなかかがすいた"
                        
                        break
                    case 38:
                        question = "怪我をする"
                        ans1 = "けがをする"
                        ans2 = "けかがをする"
                        
                        break
                    case 39:
                        question = "胸を張る"
                        ans1 = "むねをはる"
                        ans2 = "むねをはる"
                        break
                    case 40:
                        question = "家を出る"
                        ans1 = "いえをでる"
                        ans2 = "いえをてでる"
                        
                        break
                    case 41:
                        question = "爪を切る"
                        ans1 = "つめをきる"
                        ans2 = "つめをきる"
                        
                        break
                    case 42:
                        question = "パソコンを買う"
                        ans1 = "ぱそこんをかう"
                        ans2 = "はばぱそこんをかう"
                        break
                    case 43:
                        question = "希望を持つ"
                        ans1 = "きぼうをもつ"
                        ans2 = "きほぼうをもつ"
                          
                        break
                    case 44:
                        question = "原因を分析する"
                        ans1 = "げんいんをぶんせきする"
                        ans2 = "けげんいんをふぶんせきする"
                          
                        break
                    case 45:
                        question = "メモをする"
                        ans1 = "めもをする"
                        ans2 = "めもをする"
                        break
                    case 46:
                        question = "布団を干す"
                        ans1 = "ふとんをほす"
                        ans2 = "ふとんをほす"
                        
                        break
                    case 47:
                        question = "メッセージを送る"
                        ans1 = "めっせーじをおくる"
                        ans2 = "めつっせーしじをおくる"
                        
                        break
                    case 48:
                        question = "大きな箱"
                        ans1 = "おおきなはこ"
                        ans2 = "おおきなはこ"
                        break
                    case 49:
                        question = "開発する"
                        ans1 = "かいはつする"
                        ans2 = "かいはつする"
                        
                        break
                    case 50:
                        question = "時計を見る"
                        ans1 = "とけいをみる"
                        ans2 = "とけいをみる"
                        
                        break
                    case 51:
                        question = "画面を見る"
                        ans1 = "がめんをみる"
                        ans2 = "かがめんをみる"
                        break
                    case 52:
                        question = "楽しい思い出"
                        ans1 = "たのしいおもいで"
                        ans2 = "たのしいおもいてで"
                          
                        break
                    case 53:
                        question = "お金を拾う"
                        ans1 = "おかねをひろう"
                        ans2 = "おかねをひろう"
                          
                        break
                    case 54:
                        question = "悲しい記憶"
                        ans1 = "かなしいきおく"
                        ans2 = "かなしいきおく"
                        break
                    case 55:
                        question = "会議に出る"
                        ans1 = "かいぎにでる"
                        ans2 = "かいきぎにてでる"
                        
                        break
                    case 56:
                        question = "指を鳴らす"
                        ans1 = "ゆびをならす"
                        ans2 = "ゆひびをならす"
                        
                        break
                    case 57:
                        question = "人に会う"
                        ans1 = "ひとにあう"
                        ans2 = "ひとにあう"
                        break
                    case 58:
                        question = "美しい景色"
                        ans1 = "うつくしいけしき"
                        ans2 = "うつくしいけしき"
                        
                        break
                    case 59:
                        question = "ごみを捨てる"
                        ans1 = "ごみを捨てる"
                        ans2 = "こごみをすてる"
                        
                        break
                    case 60:
                        question = "気になる"
                        ans1 = "きになる"
                        ans2 = "きになる"
                        break
                    case 61:
                        question = "コートを着る"
                        ans1 = "こーとをきる"
                        ans2 = "こーとをきる"
                          
                        break
                    case 62:
                        question = "散歩する"
                        ans1 = "さんぽする"
                        ans2 = "さんほぼぽする"
                          
                        break
                    case 63:
                        question = "レベルが違う"
                        ans1 = "れべるがちがう"
                        ans2 = "れへべるかがちかがう"
                        break
                    case 64:
                        question = "ゲームに勝つ"
                        ans1 = "げーむにかつ"
                        ans2 = "けげーむにかつ"
                        
                        break
                    case 65:
                        question = "プレゼンをする"
                        ans1 = "ぷれぜんをする"
                        ans2 = "ふぶぷれせぜんをする"
                        
                        break
                    case 66:
                        question = "問題を解く"
                        ans1 = "もんだいをとく"
                        ans2 = "もんただいをとく"
                        break
                    case 67:
                        question = "項目に分ける"
                        ans1 = "こうもくにわける"
                        ans2 = "こうもくにわける"
                        
                        break
                    case 68:
                        question = "ファイルを作る"
                        ans1 = "ふぁいるをつくる"
                        ans2 = "ふあぁいるをつくる"
                        
                        break
                    case 69:
                        question = "折り紙をする"
                        ans1 = "おりがみをする"
                        ans2 = "おりかがみをする"
                        break
                    case 70:
                        question = "整理をする"
                        ans1 = "せいりをする"
                        ans2 = "せいりをする"
                          
                        break
                    case 71:
                        question = "お風呂に入る"
                        ans1 = "おふろにはいる"
                        ans2 = "おふろにはいる"
                          
                        break
                    case 72:
                        question = "ペン回しをする"
                        ans1 = "ぺんまわしをする"
                        ans2 = "へべぺんまわしをする"
                        break
                    case 73:
                        question = "肉を焼く"
                        ans1 = "にくをやく"
                        ans2 = "にくをやく"
                        
                        break
                    case 74:
                        question = "コードを書く"
                        ans1 = "こーどをかく"
                        ans2 = "こーとどをかく"
                        
                        break
                    case 75:
                        question = "裁判を行う"
                        ans1 = "さいばんをおこなう"
                        ans2 = "さいはばんをおこなう"
                        break
                    case 76:
                        question = "出席する"
                        ans1 = "しゅっせきする"
                        ans2 = "しゆゅつっせきする"
                        
                        break
                    case 77:
                        question = "お店に行く"
                        ans1 = "おみせにいく"
                        ans2 = "おみせにいく"
                        
                        break
                    case 78:
                        question = "本を読む"
                        ans1 = "ほんをよむ"
                        ans2 = "ほんをよむ"
                        break
                    case 79:
                        question = "友達と遊ぶ"
                        ans1 = "ともだちとあそぶ"
                        ans2 = "ともただちとあそふぶ"
                          
                        break
                    case 80:
                        question = "息を吸う"
                        ans1 = "いきをすう"
                        ans2 = "いきをすう"
                          
                        break
                    case 81:
                        question = "難しい問題"
                        ans1 = "むずかしいもんだい"
                        ans2 = "むすずかしいもんただい"
                        break
                    case 82:
                        question = "厳しい世界"
                        ans1 = "きびしいせかい"
                        ans2 = "きひびしいせかい"
                        
                        break
                    case 83:
                        question = "大学受験"
                        ans1 = "だいがくじゅけん"
                        ans2 = "ただいかがくしじゆゅけん"
                        
                        break
                    case 84:
                        question = "計画を立てる"
                        ans1 = "けいかくをたてる"
                        ans2 = "けいかくをたてる"
                        break
                    case 85:
                        question = "勝負に出る"
                        ans1 = "しょうぶにでる"
                        ans2 = "しよょうふぶにてでる"
                        
                        break
                    case 86:
                        question = "色をつける"
                        ans1 = "いろをつける"
                        ans2 = "いろをつける"
                        
                        break
                    case 87:
                        question = "電話に出る"
                        ans1 = "でんわにでる"
                        ans2 = "てでんわにてでる"
                        break
                    case 88:
                        question = "検討する"
                        ans1 = "けんとうする"
                        ans2 = "けんとうする"
                          
                        break
                    case 89:
                        question = "出演する"
                        ans1 = "しゅつえんする"
                        ans2 = "しゆゅつえんする"
                          
                        break
                    case 90:
                        question = "改革する"
                        ans1 = "かいかくする"
                        ans2 = "かいかくする"
                        break
                    case 91:
                        question = "暇をつぶす"
                        ans1 = "ひまをつぶす"
                        ans2 = "ひまをつふぶす"
                        break
                    case 92:
                        question = "気持ち良い"
                        ans1 = "きもちよい"
                        ans2 = "きもちよい"
                        
                        break
                    case 93:
                        question = "質問をする"
                        ans1 = "しつもんをする"
                        ans2 = "しつもんをする"
                        
                        break
                    case 94:
                        question = "時間に追われる"
                        ans1 = "じかんにおわれる"
                        ans2 = "しじかんにおわれる"
                        break
                    case 95:
                        question = "仕事に行く"
                        ans1 = "しごとにいく"
                        ans2 = "しこごとにいく"
                        
                        break
                    case 96:
                        question = "フォローする"
                        ans1 = "ふぉろーする"
                        ans2 = "ふおぉろーする"
                        
                        break
                    case 97:
                        question = "卒業する"
                        ans1 = "そつぎょうする"
                        ans2 = "そつきぎよょうする"
                        break
                    case 98:
                        question = "開拓する"
                        ans1 = "かいたくする"
                        ans2 = "かいたくする"
                          
                        break
                    case 99:
                        question = "証明する"
                        ans1 = "しょうめいする"
                        ans2 = "しよょうめいする"
                          
                        break
                  default:
                    question = "優れている"
                    ans1 = "すぐれている"
                    ans2 = "すくぐれている"
                    break
                  }
               

                }
}
}
