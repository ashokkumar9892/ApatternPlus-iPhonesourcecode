//
//  LoginVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit

class LoginVC:CustomiseViewController {
    var viewModel:RegistrationViewModel!
    @IBOutlet weak var txt_Email:BindingAnimatable!{
        didSet{
            txt_Email.bind{[unowned self] in self.viewModel.username.value = $0 }
        }
    }
    @IBOutlet weak var txt_Password:BindingAnimatable!{
        didSet{
            txt_Password.bind{[unowned self] in self.viewModel.password.value = $0 }
        }
    }
    var iconClick = true
    var tap = UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RegistrationViewModel.init(type: .SignIn)
        self.setUpVM(model: self.viewModel)
        self.addTapgesture(view: self.txt_Password.rightView ?? UIView())
        self.viewModel.didFinishFetch = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC else {return}
                vc.userdetails = self.viewModel.login_Info ?? nil
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    fileprivate func addTapgesture(view:UIView){
        tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if(iconClick == true) {
            txt_Password.isSecureTextEntry = false
            txt_Password.rightImage = UIImage(named: "eye_off")
            self.txt_Password.rightView?.removeGestureRecognizer(tap)
            self.addTapgesture(view: self.txt_Password.rightView ?? UIView())
        } else {
            txt_Password.isSecureTextEntry = true
            txt_Password.rightImage = UIImage(named: "eye_show")
            self.txt_Password.rightView?.removeGestureRecognizer(tap)
            self.addTapgesture(view: self.txt_Password.rightView ?? UIView())
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func login_Btn(_ sender :UIButton){
        if self.viewModel.isValid{
            self.viewModel.signIn()
        }else{
            self.showErrorMessages(message: self.viewModel.brokenRules.first?.message ?? "")
        }
    }
    
    @IBAction func forgetpassword_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



