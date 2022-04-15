//
//  SkyFloatingTextfieldWithIcon+Binding.swift
//  POD
//
//  Created by Rahul Gupta on 09/02/22.
//

import UIKit
import IBAnimatable

// MARK:- Creating Binding UI for the UITextField
@IBDesignable
class BindingAnimatable : AnimatableTextField {
    var textChanged :(String) -> () = { _ in }
    func bind(callback :@escaping (String) -> ()) {
        self.textChanged = callback
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    @objc func textFieldDidChange(_ textField :UITextField) {
        print(textField.text!)
        self.textChanged(textField.text!)
    }
}
