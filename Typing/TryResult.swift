//
//  TryResult.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/05/01.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit

class TryResult: UIViewController {
    
    @IBOutlet weak var gouhi: UILabel!
    @IBOutlet weak var lpmLabel: UILabel!
    @IBOutlet weak var usedTimeLabel: UILabel!
    @IBOutlet weak var missLabel: UILabel!
    @IBOutlet weak var goHome: UIButton!
    
    @IBOutlet weak var flower: UIImageView!
    
    

    var lpmNum:Double = 0
    var usedTimeNum:Double = 0
    var missNum:Int = 0
    var upOrDown2:Int = 0
    let comment = ["昇段！","ステイ！","降段.."]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)
        // Do any additional setup after loading the view.
        gouhi.text = comment[upOrDown2]
        lpmLabel.text = String(lpmNum)
        usedTimeLabel.text = String(usedTimeNum)
        missLabel.text = String(missNum)
    }
    
    @IBAction func goHome(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.presentingViewController?
            .dismiss(animated: true, completion: nil)
      
    }
    

}
