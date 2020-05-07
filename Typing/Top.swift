//
//  Top.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/04/29.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit



class Top: UIViewController {
    
    let exp = [0,0,50,56,62,120,130,142,156,172,190,210,1000]
    var level:Int = 0
    var expPoint2 = 0
    var tryCount = 0
    
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
    
   
    
   let rankName = ["一級","初段","二段","三段","四段","五段","六段","七段","八段","九段","十段"]
    
   var rankNumber = 0
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        word.setBackgroundImage(UIImage(named:"単語"), for: .normal)
        sentence.setBackgroundImage(UIImage(named:"長文"), for: .normal)
        English.setBackgroundImage(UIImage(named:"英語"), for: .normal)
        anki.setBackgroundImage(UIImage(named:"暗記"), for: .normal)
        toTry.setBackgroundImage(UIImage(named:"syodan"), for: .normal)
        
        aaaaa.image = UIImage(named: "上のやつ")
        happa.image = UIImage(named: "葉っぱ")
        
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)
        
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
        performSegue(withIdentifier: "toQuestion1", sender: word)
    }
    
    @IBAction func toQuestion2(_ sender: UIButton) {
         performSegue(withIdentifier: "toQuestion2", sender: sentence)
    }
    
    @IBAction func toQuestion3(_ sender: UIButton) {
        performSegue(withIdentifier: "toQuestion3", sender: English)
    }
    
    @IBAction func toQuestion4(_ sender: UIButton) {
        performSegue(withIdentifier: "toQuestion4", sender: anki)
    }
    
    @IBAction func toBeforeTry(_ sender: UIButton) {
        
        if tryCount <= 2 {
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
        let calendar = Calendar.current
        let nowDay = Date(timeIntervalSinceNow: 60 * 60 * 9)
        var judge = Bool()

        if UD.object(forKey: "today") != nil{
            let pastDay = UD.object(forKey: "today") as! Date
            let now = calendar.component(.day, from: nowDay)
            let past = calendar.component(.day, from: pastDay)

            //日にちが変わっていた場合
            if now != past {
                judge = true
                UD.set(nowDay, forKey: "today")
            }
        }//if
        //初回実行のみelse
        else{
            judge = true
            UD.set(nowDay, forKey:  "today")
        }

        if judge == true{
            judge = false
            tryCount = 0
            userDefaults1.set(tryCount, forKey: "tryCount")
            Time.text = String(tryCount)
        }

    }

    @IBAction func minus(_ sender: Any) {
        tryCount -= 1
        Time.text = String(tryCount)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
