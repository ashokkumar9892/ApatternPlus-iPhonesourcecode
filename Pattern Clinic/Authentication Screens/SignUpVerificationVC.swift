//
//  SignUpVerificationVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 04/05/22.
//

import UIKit

class SignUpVerificationVC: CustomiseViewController {
    @IBOutlet weak var otpView: VPMOTPView!
    var enteredOtp: String = ""
    var userdetails : LoginResponseModel?
    var email:String?
    var viewModel:RegistrationViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RegistrationViewModel.init(type: .OTPVerification)
        self.setUpVM(model:self.viewModel)
        
        otpView.delegate = self
        self.viewModel.username.value = self.email ?? ""
        otpView.shouldAllowIntermediateEditing = false
        otpView.initializeUI()
    }
    
    @IBAction func verify_OTP(_ sender :UIButton){
        self.viewModel.verifyOTP()
        self.viewModel.didFinishFetch = { [weak self] in
            guard let self = self else {return}
            Dispatch.main{
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC else {return}
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    

}
extension SignUpVerificationVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
      
        return true
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        enteredOtp = otpString
        self.viewModel.confirmationcode.value = enteredOtp
        print("OTPString: \(otpString)")
    }
}
