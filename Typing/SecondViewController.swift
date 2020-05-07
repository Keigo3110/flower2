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
    
    @IBOutlet weak var flower: UIImageView!
    
    
    var misss:String = ""
    var usedTimee:Double = 0
    var rrrecorddd:[Double] = [0,0,0]
    var wpmmm:String = ""
    var letterCount2:Double = 0
    var time = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)
        backHome.setBackgroundImage(UIImage(named:"木枠2"), for: .normal)
        back.setBackgroundImage(UIImage(named:"木枠2"), for: .normal)

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
        
        let vc1 = self.presentingViewController as! ViewController
        vc1.count = 0
        vc1.abc = true
        vc1.quesCount = 0
        vc1.usedTime1 = 0
        vc1.letterCount = 0
        vc1.timerr = [10,0,0]
        vc1.stop = false
        
        vc1.loadView()
        vc1.viewDidLoad()
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backtoHome(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
 

}
