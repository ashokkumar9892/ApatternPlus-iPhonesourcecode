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
    
    func createProfile(SK:String = "",Height:String = "",AuthToken:String = "",Weight:String = "",FirstName:String = "",LastName:String,Email:String = "",Country:String = "",ProfilePic:String = "", completion: @escaping ((Result<LoginResponseModel,APIError>) -> Void)){
        let param = [
            "SK"         :  SK,
            "Height"     :  Height,
            "AuthToken"  :  AuthToken,
            "Weight"     :  Weight,
            "FirstName"  :  FirstName,
            "LastName"   :  LastName,
            "Email"      :  Email,
            "Country"    :  Country,
            "ProfilePic" : ProfilePic
        ]
        handleAPICalling(request: .createProfile(param: param), completion: completion)
    }
}

