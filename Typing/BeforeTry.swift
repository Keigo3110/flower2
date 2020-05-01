//
//  BeforeTry.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/05/01.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit

class BeforeTry: UIViewController {
    
    @IBOutlet weak var danni: UILabel!
    @IBOutlet weak var jouken1: UILabel!
    @IBOutlet weak var jouken2: UILabel!
    @IBOutlet weak var yes: UIButton!
    @IBOutlet weak var no: UIButton!
    
    var rankNum = 0
    let rank = ["一級","初段","二段","三段","四段","五段","六段","七段","八段","九段","十段"]
    
    let up = ["lpm100以上","lpm110以上","lpm120以上","lpm130以上","lpm140以上","lpm150以上","lpm160以上","lpm170以上","lpm180以上","lpm190以上","lpm200以上"]
    
    let down = ["なし","lpm80以下","lpm90以下","lpm100以下","lpm120以下","lpm130以下","lpm140以下","lpm150以下","lpm160以下","lpm170以下","lpm180以上"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        danni.text = rank[rankNum]
        jouken1.text = up[rankNum]
        jouken2.text = down[rankNum]
        
        
    }
    
    @IBAction func NoAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func YesAction(_ sender: Any) {
        
    }
    

}
