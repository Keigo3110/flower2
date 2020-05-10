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
    

    @IBOutlet weak var personname: UILabel!
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
    var person = ""
    var TimerStartOrNot = false
    let userDefaults3 = UserDefaults.standard
    let up:[Double] = [80,110,130,150,170,190,210,220,230,250,1000]
    let down:[Double] = [0,80,110,130,150,170,190,210,220,230,0]
    
    
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
               bgmPlayer?.numberOfLoops = -1
               bgmPlayer?.prepareToPlay()
               bgmPlayer?.play()
           } catch let error as NSError {
               audioError = error
               bgmPlayer = nil
           }
           if let error = audioError {
                          print("Error")
                      }
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
        personname.text = person
        question2.text = question
        ansLabel.text = ans1
        userDefaults3.register(defaults: ["rankNum2" : 0])
        
        SaveRankNum2(num: rankNum2)
        
        rankNum2 = userDefaults3.object(forKey: "rankNum2") as! Int
        counting.text = "\(quesCount2+1)/5"
        
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
        if quesCount2<4{
        if field.text! == ans1{
            music(sound: "パッ")
            field.text = ""
            quesCount2 += 1
            letterCount2 += ans1.count
            changeFlowers(index: quesCount2)
            counting.text = "\(quesCount2+1)/5"
            Random()
            personname.text = person
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
        if index >= 1 {
            flower.image = UIImage(named: "花2")
            flowers = 1
        }
        if index >= 2 {
            flower.image = UIImage(named: "花3")
            flowers = 2
        }
        if index >= 3 {
            flower.image = UIImage(named: "花4")
            flowers = 3
        }
    }
    
    
    
    
   func Random(){
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
    
    
    
}

