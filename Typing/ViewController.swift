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


class ViewController: UIViewController {
    
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
    
    func shortVibrate() {
        AudioServicesPlaySystemSound(1003);
        AudioServicesDisposeSystemSoundID(1003);
    }
    
    
    
    
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
    

    var timerr: [Int] = [30,0,0]
    var timerr2:Double = 0.1
    @IBOutlet weak var time: UILabel!
    
    

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
                        //震えるやつ
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
           var randomNumber = arc4random() % 4
           randomNumber += 1
        if choice == 0{
           switch (randomNumber) {
           case 1:
               question = "ああ"
               
               break
           case 2:
               question = "いい"
               break
           case 3:
               question = "うう"
               break
           default:
               question = "ええ"
               break
           }
        }
        
        
        if choice == 1{
           switch (randomNumber) {
           case 1:
               question = "信号"
               ans1 = "しんごう"
               ans2 = "しんこごう"
               
               
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
               question = "word"
               
               break
           case 2:
               question = "take"
               break
           case 3:
               question = "and"
               break
           default:
               question = "look"
               break
           }
        }
        if choice == 3{
           switch (randomNumber) {
           case 1:
               question = "あかさたな"
               
               break
           case 2:
               question = "いきしちに"
               break
           case 3:
               question = "うくすつぬ"
               break
           default:
               question = "えけせてね"
               break
           }
        }
        
        
           
           
       }
 
    
}

