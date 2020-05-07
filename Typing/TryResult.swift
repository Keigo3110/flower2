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
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var lpmLabel: UILabel!
    @IBOutlet weak var missLabel: UILabel!
    @IBOutlet weak var goHome: UIButton!
    @IBOutlet weak var newRank: UILabel!
    
    @IBOutlet weak var flower: UIImageView!
    
    

    var lpmNum:Double = 0
    var usedTimeNum:Double = 0
    var missNum:Int = 0
    var upOrDown2:Int = 0
    var new = 0
    let comment1 = ["おめでとう！","残念！","残念.."]
    let comment2 = ["1段昇格です！", "昇格ならず..", "1段降格です.."]
    let rankName = ["一級","初段","二段","三段","四段","五段","六段","七段","八段","九段","十段"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)
        // Do any additional setup after loading the view.
        gouhi.text = comment1[upOrDown2]
        comment.text = comment2[upOrDown2]
        lpmLabel.text = String(lpmNum)
        missLabel.text = String(missNum)
        newRank.text = rankName[new]
    }
    
    @IBAction func goHome(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.presentingViewController?
            .dismiss(animated: true, completion: nil)
      
    }
    

}
