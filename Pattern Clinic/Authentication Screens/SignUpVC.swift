//
//  SignUpVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 29/04/22.
//

import UIKit

class SignUpVC: CustomiseViewController {
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
    @IBOutlet weak var txt_ConfirmPassword:BindingAnimatable!{
        didSet{
            txt_ConfirmPassword.bind{[unowned self] in self.viewModel.confirmPasswrd.value = $0 }
        }
    }
    var tap = UITapGestureRecognizer()
    var iconClick = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = RegistrationViewModel.init(type: .signup)
        self.setUpVM(model: self.viewModel)
        self.addTapgesture(view: self.txt_Password.rightView ?? UIView())
        self.txt_ConfirmPassword.rightView?.tag = 1
        self.addTapgesture(view: self.txt_ConfirmPassword.rightView ?? UIView())
        self.viewModel.didFinishFetch = { [weak self] in
            guard let self = self else {return}
            Dispatch.main{
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC else {return}
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    fileprivate func addTapgesture(view:UIView){
        tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if sender?.view?.tag == 0{
            if(iconClick == true) {
                addPasswordFeatures(password: self.txt_Password, name: "eye_off",bool: false)
            } else {
                addPasswordFeatures(password: self.txt_Password, name: "eye_show",bool: true)
            }
        }else{
            if(iconClick == true) {
                addPasswordFeatures(password: self.txt_ConfirmPassword, name: "eye_off",bool: false)
            } else {
                addPasswordFeatures(password: self.txt_ConfirmPassword, name: "eye_show",bool: true)
            }
        }
        iconClick = !iconClick
    }
    
    fileprivate func addPasswordFeatures(password:BindingAnimatable,name:String,bool:Bool){
        password.isSecureTextEntry = bool
        password.rightImage = UIImage(named: name)
        password.rightView?.removeGestureRecognizer(tap)
        self.txt_ConfirmPassword.rightView?.tag = 1
        self.addTapgesture(view:password.rightView ?? UIView())
    }
    
    @IBAction func login_Btn(_ sender :UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signup_Btn(_ sender :UIButton){
        if self.viewModel.isValid{
            self.viewModel.signupapi_call()
        }else
        {
            self.showErrorMessages(message: self.viewModel.brokenRules.first?.message ?? "")
        }
    }
}
