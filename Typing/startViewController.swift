//
//  startViewController.swift
//  Typing
//
//  Created by 大原拓真 on 2020/05/07.
//  Copyright © 2020 斉藤啓悟. All rights reserved.
//

import UIKit


class start: UIViewController {

    @IBOutlet weak var flower: UIImageView!
    @IBOutlet weak var happa: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        flower.image = UIImage(named: "花5")
        happa.image = UIImage(named:"葉っぱ")
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 251/255.0, blue: 241/255.0, alpha: 1.0)

        // Do any additional setup after loading the view.
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
