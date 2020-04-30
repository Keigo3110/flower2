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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
