//
//  Top.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/04/29.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit



class Top: UIViewController {
    
    let exp = [0,0,2,6,12,20,30,42,56,72,90,110,1000]
    var level:Int = 0
    var expPoint2 = 0
    
    let userDefaults1 = UserDefaults.standard
    
    @IBOutlet weak var word: UIButton!
    @IBOutlet weak var sentence: UIButton!
    @IBOutlet weak var English: UIButton!
    @IBOutlet weak var exppp: UILabel!
    
   
    
    var int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

       userDefaults1.register(defaults: ["expPoint2" : 0])
        
        if expPoint2 >= 1{
        userDefaults1.set(expPoint2, forKey: "expPoint2")
        }
        
        expPoint2 = userDefaults1.object(forKey: "expPoint2") as! Int
        
        levelJudge()
    
        
        exppp.text = String(level)
        
        
        

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
}
}
