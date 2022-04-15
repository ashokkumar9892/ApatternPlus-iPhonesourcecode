//
//  ForgetPasswordVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit

class ForgetPasswordVC: CustomiseViewController {
    var viewModel:RegistrationViewModel!
    @IBOutlet weak var txt_Email:BindingAnimatable!{
        didSet{
            txt_Email.bind{[unowned self] in self.viewModel.username.value = $0 }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RegistrationViewModel.init(type: .ForgetPassword)
        self.setUpVM(model: self.viewModel)
        self.viewModel.didFinishFetch = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC else {return}
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func reset_Btn(_ sender :UIButton){
        if self.viewModel.isValid{
            self.viewModel.forgetPassword()
        }else{
            self.showErrorMessages(message: self.viewModel.brokenRules.first?.message ?? "")
        }
    }
}
