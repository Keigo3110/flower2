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
    @IBOutlet weak var no: UIButton!
    
    var rankNum = 0
    let rankName = ["一級","初段","二段","三段","四段","五段","六段","七段","八段","九段","十段"]
    
    let up = ["lpm100以上","lpm120以上","lpm140以上","lpm160以上","lpm140以上","lpm150以上","lpm160以上","lpm170以上","lpm180以上","lpm190以上","lpm200以上"]
    
    let down = ["なし","lpm80未満","lpm90未満","lpm100未満","lpm120未満","lpm130未満","lpm140未満","lpm150未満","lpm160未満","lpm170未満","lpm180未満"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        danni.text = rankName[rankNum]
        jouken1.text = up[rankNum]
        jouken2.text = down[rankNum]
        
        
    }
    
    @IBAction func NoAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "toTry"{
//        let tryView = segue.destination as! Try
//        tryView.rankNum2 =
//    }
    
    

}
