//
//  OTPVerificationVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 04/05/22.
//

import UIKit

class OTPVerificationVC: UIViewController {
@IBOutlet weak var otpView:VPMOTPView!
    
override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // otpTextFieldView.otpFieldsCount = 6
//        otpTextFieldView.otpFieldDefaultBorderColor = UIColor.blue
//        otpTextFieldView.otpFieldEnteredBorderColor = UIColor.green
//        otpTextFieldView.otpFieldErrorBorderColor = UIColor.red
       // otpTextFieldView.otpFieldBorderWidth = 2
        otpView.delegate = self
        otpView.shouldAllowIntermediateEditing = false
        
        // Create the UI
        otpView.initializeUI()
    }

}

extension OTPVerificationVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
       // enteredOtp = otpString
        print("OTPString: \(otpString)")
    }
}
