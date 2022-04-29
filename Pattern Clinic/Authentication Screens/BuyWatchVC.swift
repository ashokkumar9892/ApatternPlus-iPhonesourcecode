//
//  BuyWatchVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 29/04/22.
//

import UIKit

class BuyWatchVC: CustomiseViewController {
    var callback:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func yes_Proceed(_ sender :UIButton){
        self.callback?()
        self.dismiss(animated: true, completion: nil)
    }

}
