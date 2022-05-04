//
//  SignUpVerificationVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 04/05/22.
//

import UIKit

class SignUpVerificationVC: UIViewController {
    @IBOutlet weak var otpView: VPMOTPView!
    var enteredOtp: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      
        otpView.delegate = self
  
        otpView.shouldAllowIntermediateEditing = false
        otpView.initializeUI()
    }
    

    

}
extension SignUpVerificationVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        
        return enteredOtp == "12345"
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        enteredOtp = otpString
        print("OTPString: \(otpString)")
    }
}
