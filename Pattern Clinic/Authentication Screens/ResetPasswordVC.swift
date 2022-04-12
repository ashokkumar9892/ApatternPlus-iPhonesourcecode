//
//  ResetPasswordVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit

class ResetPasswordVC: CustomiseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    

    @IBAction func submit_Btn(_ sender :UIButton){
        self.navigationController?.popToViewController(ofClass:LoginVC.self)
    }

}
