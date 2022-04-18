//
//  ApiEndPintManager.swift
//  Muselink
//
//  Created by HarishParas on 18/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

//Registration Apis
extension NetworkManager {
    func login(Username:String = "", Password:String = "", completion: @escaping ((Result<LoginResponseModel,APIError>) -> Void)) {
        let param = [
            "Username"             : Username,
            "Password"             : Password
        ]
        handleAPICalling(request: .logIn(param: param), completion: completion)
    }
    func forgetPassword(UserName:String,completion: @escaping ((Result<LoginResponseModel,APIError>) -> Void)){
        let param = [
            "UserName"             : UserName
        ]
        handleAPICalling(request: .forgetPassword(param: param), completion: completion)
    }
    
    func resetPassword(username:String,confirmationcode:String = "",newpassword:String = "",completion: @escaping ((Result<Basic_Model,APIError>) -> Void)){
        let param = [
            "username"             : username,
            "newpassword"          : newpassword,
            "confirmationcode"     : confirmationcode
        ]
        handleAPICalling(request: .resetPasswordApi(param: param), completion: completion)
    }
    
    func createProfile(SK:String = "",Height:String = "",AuthToken:String = "",Weight:String = "",FirstName:String = "",LastName:String,Email:String = "",Country:String = "",ProfilePic:String = "",DOB:String = "", Gender:String = "",ReferAs:String = "",completion: @escaping ((Result<LoginResponseModel,APIError>) -> Void)){
        let param = [
            "SK"         :  SK,
            "Height"     :  Height,
            "AuthToken"  :  AuthToken,
            "Weight"     :  Weight,
            "FirstName"  :  FirstName,
            "LastName"   :  LastName,
            "Email"      :  Email,
            "Country"    :  Country,
            "ProfilePic" : ProfilePic,
            "DOB"        : DOB,
            "Gender"     : Gender,
            "ReferAs"    : ReferAs
         ]
        handleAPICalling(request: .createProfile(param: param), completion: completion)
    }
    
    func getDoctorsList(completion: @escaping ((Result<GetDoctorsList,APIError>) -> Void)){
        let param = [
            "AuthToken"  :  UserDefaults.userToken
        ]
        handleAPICalling(request: .getDectorList(param: param), completion: completion)
    }
   
    
    func getCoatchList(completion: @escaping ((Result<GetDoctorsList,APIError>) -> Void)){
        let param = [
            "AuthToken"  :  UserDefaults.userToken
        ]
        handleAPICalling(request: .getcoachList(param:param), completion: completion)
    }
}

