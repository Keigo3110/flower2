//
//  Try.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/04/30.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit

class Try: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var question2: UILabel!
    @IBOutlet weak var ans2: UILabel!
    @IBOutlet weak var shiji: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var field: UITextField!
    

    
    var count2 = 0
    var abc2 = true
    var quesCount2 = 0
    var myTimer2: Timer!
    var usedTime2 :Double = 0
    var letterCount2 = 0
    var lpm2:Double = 0
    var rankNum2 = 0
    var upOrDown = 0
    let userDefaults3 = UserDefaults.standard
    let up:[Double] = [100,120,140,160,180,150,160,170,180,190,200]
    let down:[Double] = [0,80,90,100,110,120,130,140,150,160,170]
    
    var timerr2:[Int] = [0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        shiji.isHidden = false
        count2 = 0
        time.text = String(timerr2[0])+":"+String(timerr2[1])+String(timerr2[2])
        
        
        Random2()
        
        userDefaults3.register(defaults: ["rankNum2" : 0])
    }
    
    @objc func timer(){
        if (timerr2[0] == 0 && timerr2[1] == 0 && timerr2[2] == 0) {
            performSegue(withIdentifier: "toTryResult", sender: nil)
            
        } else {
            if timerr2[2] > 0 {
                //秒数が0以上の時秒数を-1
                timerr2[2] -= 1
            } else {
                //秒数が0の時
                timerr2[2] += 9
                if timerr2[1] > 0 {
                    //分が0以上の時、分を-1
                    timerr2[1] -= 1
                } else {
                    //分が０の時、+59分、時間-1
                    timerr2[1] += 9
                    timerr2[0] -= 1
                }
            }
            time.text = String(timerr2[0]) + ":" + String(timerr2[1])+String(timerr2[2])
        }
    }
    
    
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        //myTimer2.invalidate()
    }
    
    @IBAction func EditingDidBegin(_ sender: Any) {
        shiji.isHidden = true
        myTimer2 = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:#selector(timer) , userInfo: nil, repeats: true)
    }
    
    @IBAction func EditingChanged(_ sender: Any) {
        judge2()
    }
    
    func judge2(){
        if quesCount2<1{
        if field.text! == question2.text!{
            Random2()
            abc2 = true
            field.text = ""
            quesCount2 += 1
            letterCount2 += question2.text!.count
        }else if field.text! == question2.text!.prefix(field.text!.count){
            abc2 = true
           ans2.text = String(question2.text!.suffix(question2.text!.count-field.text!.count))
            
            
            
           }else if abc2 == true{
               count2 += 1
               abc2 = false
           }else{
                abc2 = false
           }
        }else{
            if field.text! == question2.text!{
                
               
                field.text = ""
                ans2.text = ""
                quesCount2 = 0
                letterCount2 += question2.text!.count
                
                myTimer2.invalidate()
                
                
                
                usedTime2 = 30 - Double(timerr2[0]) - Double(timerr2[1])/10 - Double(timerr2[2])/100
                
              
                
                 lpm2 = round(60*Double(letterCount2)/usedTime2)
                
                 rankNum2 = userDefaults3.object(forKey: "rankNum2") as! Int
                
                if lpm2 >= up[rankNum2]{
                    rankNum2 += 1
                    SaveRankNum2(num: rankNum2)
                    upOrDown = 0
                }else if lpm2 >= down[rankNum2]{
                    SaveRankNum2(num: rankNum2)
                    upOrDown = 1
                }else{
                    rankNum2 -= 1
                    SaveRankNum2(num: rankNum2)
                    upOrDown = 2
                    
                }
                
                let top = self.presentingViewController?.presentingViewController as! Top
                top.rankNumber = userDefaults3.object(forKey: "rankNum2") as! Int
                top.viewDidLoad()
                
                
                
                
                 performSegue(withIdentifier: "toTryResult", sender: nil)
                
            }else if field.text! == question2.text!.prefix(field.text!.count){
             abc2 = true
            ans2.text = String(question2.text!.suffix(question2.text!.count-field.text!.count))
            
             
             
            }else if abc2 == true{
                count2 += 1
                 abc2 = false
            }else{
                 abc2 = false
            }
        }//else
    }//judge
    
    
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
        }
    }
    
    
    func Random2(){
        var randomNumber = arc4random() % 4
        randomNumber += 1
        
        switch (randomNumber) {
        case 1:
            question2.text = "あいうえお"
            
            break
        case 2:
            question2.text = "かきくけこ"
            break
        case 3:
            question2.text = "さしすせそ"
            break
        default:
            question2.text = "もはじすあ"
            break
        }
        ans2.text = question2.text!
    }
    
    
    
    
    
    
    
    
    
    
    
}

