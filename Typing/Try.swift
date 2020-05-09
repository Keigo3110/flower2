//
//  Try.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/04/30.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation
import AudioToolbox

class Try: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var question2: UILabel!
    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var shiji: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var jouro: UIImageView!
    @IBOutlet weak var flower: UIImageView!
    @IBOutlet weak var counting: UILabel!
    

    var audioPlayer: AVAudioPlayer!
    var bgmPlayer: AVAudioPlayer!
    var count2 = 0
    var abc2 = true
    var quesCount2 = 0
    var myTimer2: Timer!
    var usedTime2 :Double = 0
    var letterCount2 = 0
    var lpm2:Double = 0
    var rankNum2 = 0
    var upOrDown = 0
    var bgm = 0
    var question = ""
    var ans1 = ""
    var ans2 = ""
    var flowers = 0
    var TimerStartOrNot = false
    let userDefaults3 = UserDefaults.standard
    let up:[Double] = [100,130,150,170,190,210,220,230,240,250,260,270,280,290,300,310,320]
    let down:[Double] = [0,120,140,160,180,200,210,220,230,240,250,260,270,280,290,300,310]
    
    
    var timerr2:[Int] = [0,0,0]
    
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
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)
        flower.image = UIImage(named: "花1")

        shiji.isHidden = false
        count2 = 0
        time.text = String(timerr2[0])+":"+String(timerr2[1])+String(timerr2[2])
        
        
        Random()
        question2.text = question
        ansLabel.text = ans1
        userDefaults3.register(defaults: ["rankNum2" : 0])
        
        SaveRankNum2(num: rankNum2)
        
        rankNum2 = userDefaults3.object(forKey: "rankNum2") as! Int
        counting.text = "\(quesCount2+1)/10"
        
    }
    
    @objc func timer(){
    
        if timerr2[2] >= 0{
            timerr2[2] += 1
        }
        if timerr2[2] == 9 {
            timerr2[2] = 0
            timerr2[1] += 1
        }
        if timerr2[1] == 9{
            timerr2[1] = 0
            timerr2[0] += 1
        }
    time.text = String(timerr2[0]) + ":" + String(timerr2[1])+String(timerr2[2])

    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        music(sound: "button")
        let top = self.presentingViewController?.presentingViewController as! Top
        
        if rankNum2 >= 1{
        rankNum2 = userDefaults3.object(forKey: "rankNum2") as! Int
        rankNum2 -= 1
        SaveRankNum2(num: rankNum2)
        
        top.rankNumber = userDefaults3.object(forKey: "rankNum2") as! Int
        top.viewDidLoad()
        }
        top.dismiss(animated: true, completion: nil)
        
        if TimerStartOrNot == true{
        myTimer2.invalidate()
        }
        
    }
    
    @IBAction func EditingDidBegin(_ sender: Any) {
        shiji.isHidden = true
        myTimer2 = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:#selector(timer) , userInfo: nil, repeats: true)
        TimerStartOrNot = true
        if bgm == 0 {
            bgm += 1
            bgmmusic(sound: "草原の小鳥")
        } else{
            bgmPlayer.play()
        }
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat], animations: {
            self.jouro.transform = CGAffineTransform(rotationAngle: CGFloat.pi/10)
        }, completion: nil)
                
    }
    

    
    @IBAction func EditingChanged(_ sender: Any) {
        judge2()
        misJudge2()
    }
    
    func judge2(){
        if quesCount2<9{
        if field.text! == ans1{
            music(sound: "パッ")
            field.text = ""
            quesCount2 += 1
            letterCount2 += ans1.count
            changeFlowers(index: quesCount2)
            counting.text = "\(quesCount2+1)/10"
            Random()
            question2.text = question
            ansLabel.text = ans1
        }else if field.text! == ans1.prefix(field.text!.count){
            ansLabel.text = String(ans1.suffix(ans1.count-field.text!.count))
            

           }
        }else{
            if field.text! == ans1{
                
                bgmPlayer.stop()
                field.text = ""
                ansLabel.text = ""
                quesCount2 = 0
                letterCount2 += ans1.count
                
                myTimer2.invalidate()
                
                
                
                usedTime2 = Double(timerr2[0]) + Double(timerr2[1])/10 + Double(timerr2[2])/100
                
              
                
                 lpm2 = round(60*Double(letterCount2)/usedTime2)
                
                 
                
                if lpm2 >= up[rankNum2]{
                    rankNum2 += 1
                    SaveRankNum2(num: rankNum2)
                    upOrDown = 0
                    music(sound: "まる")
                }else if lpm2 >= down[rankNum2]{
                    SaveRankNum2(num: rankNum2)
                    upOrDown = 1
                    music(sound: "まる")
                }else{
                    rankNum2 -= 1
                    SaveRankNum2(num: rankNum2)
                    upOrDown = 2
                    music(sound: "時間切れ")
                    
                }
                
                let top = self.presentingViewController?.presentingViewController as! Top
                top.rankNumber = userDefaults3.object(forKey: "rankNum2") as! Int
                top.viewDidLoad()
                
                
                
                 performSegue(withIdentifier: "toTryResult", sender: nil)
                
            }else if field.text! == ans1.prefix(field.text!.count){
            ansLabel.text = String(ans1.suffix(ans1.count-field.text!.count))
            
             
             
            }
        }//else
    }//judge
    
    
    func misJudge2(){
        if field.text != "" {
        
            if ans2.count >= 2{
        
                    if field.text!.suffix(1) == ans2.prefix(1){
                        ans2 = String(ans2.suffix(ans2.count - 1))
                        abc2 = true
                        }
                        
                    else if abc2 == true && field.text!.suffix(1) != ans2.prefix(1){
                        count2 += 1
                        abc2 = false
                        shortVibrate()
                        
                        }
        
        
            }else if field.text!.suffix(1) != ans2  && abc2 == true{
                    abc2 = false
                    count2 += 1
                    shortVibrate()
            }else if field.text!.suffix(1) == ans2{
                abc2 = true
                }
        
        }
        
    }
    
    
    
    func SaveRankNum2(num:Int){
        userDefaults3.set(num, forKey: "rankNum2")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toTryResult"{
        let tryRes = segue.destination as! TryResult
        tryRes.lpmNum = lpm2
        tryRes.usedTimeNum = usedTime2
        tryRes.missNum = count2
        tryRes.upOrDown2 = upOrDown
        tryRes.new = userDefaults3.object(forKey: "rankNum2") as! Int
        }
    }
    
    func changeFlowers(index: Int) {
        if index >= 3 {
            flower.image = UIImage(named: "花2")
            flowers = 1
        }
        if index >= 5 {
            flower.image = UIImage(named: "花3")
            flowers = 2
        }
        if index >= 7 {
            flower.image = UIImage(named: "花4")
            flowers = 3
        }
    }
    
    
    
    
   func Random(){
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
    
    
    
    
}

