//
//  Top.swift
//  Typing
//
//  Created by 斉藤啓悟 on 2020/04/29.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit

class Top: UIViewController {
    
    @IBOutlet weak var word: UIButton!
    @IBOutlet weak var sentence: UIButton!
    @IBOutlet weak var English: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
