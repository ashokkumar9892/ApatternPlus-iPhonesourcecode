//
//  ForgetPasswordVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit

class ForgetPasswordVC: CustomiseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func reset_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
