//
//  LoginVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit

class LoginVC:CustomiseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.changeStatusColor(colour: UIColor(named: "blue_Back"))
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.changeStatusColor(colour: .white)
    }
    @IBAction func login_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func forgetpassword_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
