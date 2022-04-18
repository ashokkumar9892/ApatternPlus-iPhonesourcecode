//
//  RegistrationViewModel.swift
//  Muselink
//
//  Created by HarishParas on 18/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import Foundation

class RegistrationViewModel :NSObject, ViewModel {
    enum ModelType {
        case SignIn
        case ForgetPassword
        case CreateProfile
        case addHeight
        case addWeight
    }
    var modelType         : ModelType
    var brokenRules       : [BrokenRule]    = [BrokenRule]()
    var username          : Dynamic<String> = Dynamic("")
    var password          : Dynamic<String> = Dynamic("")
    var full_name         : Dynamic<String> = Dynamic("")
    var last_name         : Dynamic<String> = Dynamic("")
    var country_Name      : Dynamic<String> = Dynamic("")
    var userProfile_Pic   : Dynamic<String> = Dynamic("")
    var confirmationcode  : Dynamic<String> = Dynamic("")
    
    var dob               : Dynamic<String> = Dynamic("")
    var height            : Dynamic<String> = Dynamic("")
    var weight            : Dynamic<String> = Dynamic("")
    var gender            : Dynamic<String> = Dynamic("")
    var confirmPasswrd    : Dynamic<String> = Dynamic("")
    var SK                : Dynamic<String> = Dynamic("")
    
    private var emailCode : String          = ""
    var isValid           : Bool {
        get {
            self.brokenRules = [BrokenRule]()
            self.Validate()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    init(type:ModelType) {
        modelType = type
    }
    
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    //Firebase Auth User ID
    var userID : String? {
        didSet {
            guard let _ = userID else { return }
            self.didFinishFetch?()
        }
    }
    var isSocialAccountVerified = false
    var getDoctorsList:GetDoctorsList?
    var login_Info:LoginResponseModel?
    var showText = "Please Wait..."
}

extension RegistrationViewModel {
    private func Validate() {
        switch modelType {
        case .SignIn:
            if username.value == "" || username.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "No Email", message: "⚠️ Enter Email"))
            }
            if !username.value.isValidEmail(){
                self.brokenRules.append(BrokenRule(propertyName: "InvalidEmail", message: "⚠️ Enter valid Email Address"))
            }
            if password.value == "" || password.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "NoPassword", message: "Enter Your Password"))
            }
        case .ForgetPassword:
            if username.value == "" || username.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "No Email", message: "⚠️ Enter Email"))
            }
            if !username.value.isValidEmail(){
                self.brokenRules.append(BrokenRule(propertyName: "InvalidEmail", message: "⚠️ Enter valid Email Address"))
            }
        case .CreateProfile:
            if full_name.value == "" || full_name.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "No Email", message: "Enter FirstName"))
            }
            if last_name.value == "" || last_name.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "No Email", message: "Enter LastName"))
            }
            if country_Name.value == "" || country_Name.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "No Email", message: "Select Your Country"))
            }
            if dob.value == "" || dob.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "No Email", message: "Select Your DOB"))
            }
            if gender.value == "" || gender.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "No Email", message: "Select Your Gender"))
            }
        case .addWeight:
            if weight.value == "" || weight.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "No Email", message: "Add your weight"))
            }
        case .addHeight:
            if height.value == "" || height.value == " "{
                self.brokenRules.append(BrokenRule(propertyName: "No Email", message: "add your height"))
            }
        }
    }
}

// MARK: - Network call
extension RegistrationViewModel {
    func signIn() {
        Indicator.shared.show(showText)
        let model = NetworkManager.sharedInstance
        model.login(Username: username.value, Password: password.value) { [weak self](result) in
            guard let self = self else {return}
            switch result{
            case .success(let res):
                self.login_Info = res
                UserDefaults.hasLogin = true
                UserDefaults.userToken = res.authToken ?? ""
                Indicator.shared.hide()
                self.didFinishFetch?()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    Indicator.shared.hide()
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func forgetPassword(){
        let model = NetworkManager.sharedInstance
        Indicator.shared.show(showText)
        model.forgetPassword(UserName: username.value) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let res):
                self.didFinishFetch?()
                Indicator.shared.hide()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    Indicator.shared.hide()
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func createProfile(){
        Indicator.shared.show(showText)
        let model = NetworkManager.sharedInstance
        model.createProfile(SK: SK.value, Height:height.value, AuthToken:UserDefaults.userToken, Weight: weight.value, FirstName: full_name.value, LastName: last_name.value, Email:username.value, Country: country_Name.value, ProfilePic:userProfile_Pic.value,DOB: dob.value,Gender: gender.value,ReferAs:"") { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let res):
                self.didFinishFetch?()
                Indicator.shared.hide()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    Indicator.shared.hide()
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func getDectors_Info(){
        let model = NetworkManager.sharedInstance
        Indicator.shared.show(showText)
        model.getDoctorsList { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let res):
                self.getDoctorsList = res
                self.didFinishFetch?()
                Indicator.shared.hide()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    Indicator.shared.hide()
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func getCoatchList(){
        Indicator.shared.show(showText)
        let model = NetworkManager.sharedInstance
        model.getCoatchList {  [weak self] (result) in
            guard let self = self else {return}
            Indicator.shared.hide()
            switch result{
            case .success(let res):
                self.getDoctorsList = res
                self.didFinishFetch?()
                Indicator.shared.hide()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    Indicator.shared.hide()
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    func resetPassword(){
        Indicator.shared.show(showText)
        let model = NetworkManager.sharedInstance
        model.resetPassword(username: username.value, confirmationcode:confirmationcode.value, newpassword: password.value) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success( _ ):
                self.didFinishFetch?()
                Indicator.shared.hide()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    Indicator.shared.hide()
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
}
