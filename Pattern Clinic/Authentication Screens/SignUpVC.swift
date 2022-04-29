//
//  SignUpVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 29/04/22.
//

import UIKit

class SignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func login_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
