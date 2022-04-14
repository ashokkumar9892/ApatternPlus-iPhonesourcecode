//
//  HealthTipDetailsVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 12/04/22.
//

import UIKit

class HealthTipDetailsVC: CustomiseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func subscribe_Btn(_ sender:UIButton){
        if sender.isSelected == false{
            sender.isSelected = true
            sender.setTitle("Unsubscribe", for: .normal)
        }else{
            sender.setTitle("Subscribe", for: .normal)
            sender.isSelected = false
        }
    }

}



