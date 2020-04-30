//
//  SecondViewController.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/04/28.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var mis: UILabel!
    @IBOutlet weak var usedTime: UILabel!
    @IBOutlet weak var rrrecord: UILabel!
    @IBOutlet weak var wpm: UILabel!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var backHome: UIButton!
    @IBOutlet weak var timeOut: UILabel!
    
    
    
    var misss:String = ""
    var usedTimee:Double = 0
    var rrrecorddd:[Double] = [0,0,0]
    var wpmmm:String = ""
    var letterCount2:Double = 0
    var time = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mis.text = misss
        usedTime.text = String(usedTimee)
        rrrecord.text = String(rrrecorddd[0])+","+String(rrrecorddd[1])+","+String(rrrecorddd[2])
        wpm.text = String(round(60*letterCount2/usedTimee))
        
        if time == true{
            timeOut.text = "時間切れ！！"
        }else{
            timeOut.text = "クリア！！"
        }
        
        
            }
    
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backtoHome(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    


}
