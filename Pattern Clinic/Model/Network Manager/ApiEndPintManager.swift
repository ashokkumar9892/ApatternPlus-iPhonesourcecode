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
    //MARK: - SignUp api Call
    func signUpapi_Call(Username:String = "", Password:String = "", completion: @escaping ((Result<LoginResponseModel,APIError>) -> Void)){
        let param = [
            "Username"             : Username,
            "Password"             : Password
        ]
        handleAPICalling(request: .Signup(param: param), completion: completion)
    }
    
    //MARK: - Login api Call
    func login(Username:String = "", Password:String = "", completion: @escaping ((Result<LoginResponseModel,APIError>) -> Void)) {
        let param = [
            "Username"             : Username,
            "Password"             : Password,
            "DeviceToken"          : UserDefaults.fcmToken,
            "DeviceType"           : "iOS"
        ]
        handleAPICalling(request: .logIn(param: param), completion: completion)
    }
    //MARK: - Verify Otp api Call
    func verifyOTP(confirmationcode:String = "",Username:String = "",completion: @escaping ((Result<LoginResponseModel,APIError>) -> Void)){
        let param = [
            "Username"             : Username,
            "confirmationcode"     : confirmationcode,
            "DeviceToken"          : UserDefaults.fcmToken,
            "DeviceType"           : "iOS"
        ]
        handleAPICalling(request: .verifyOTP(param: param), completion: completion)
    }
    
    //MARK: - Forget password  api Call
    func forgetPassword(UserName:String,completion: @escaping ((Result<LoginResponseModel,APIError>) -> Void)){
        let param = [
            "UserName"             : UserName
        ]
        handleAPICalling(request: .forgetPassword(param: param), completion: completion)
    }
    //MARK: - Reset password  api Call
    func resetPassword(username:String,confirmationcode:String = "",newpassword:String = "",completion: @escaping ((Result<Basic_Model,APIError>) -> Void)){
        let param = [
            "username"             : username,
            "newpassword"          : newpassword,
            "confirmationcode"     : confirmationcode
        ]
        handleAPICalling(request: .resetPasswordApi(param: param), completion: completion)
    }
    //MARK: - Create Profile api Call
    func createProfile(SK:String = "",Height:String = "",AuthToken:String = "",Weight:String = "",FirstName:String = "",LastName:String,Email:String = "",Country:String = "",ProfilePic:String = "",DOB:String = "", Gender:String = "",ReferAs:String = "",username:String = "",completion: @escaping ((Result<LoginResponseModel,APIError>) -> Void)){
        let param = [
            "SK"         :  SK,
            "username"   :  username,
            "Height"     :  Height,
            "AuthToken"  :  AuthToken,
            "Weight"     :  Weight,
            "FirstName"  :  FirstName,
            "LastName"   :  LastName,
            "Email"      :  Email,
            "Country"    :  Country,
            "ProfilePic" :  ProfilePic,
            "DOB"        :  DOB,
            "Gender"     :  Gender,
            "ReferAs"    :  ReferAs,
            "WeightUnit" :  "Kg"
        ]
        handleAPICalling(request: .createProfile(param: param), completion: completion)
    }
    //MARK: - Get All Dectors list  api Call
    func getDoctorsList(completion: @escaping ((Result<GetDoctorsList,APIError>) -> Void)){
        let param = [
            "AuthToken"  :  UserDefaults.userToken
        ]
        handleAPICalling(request: .getDectorList(param: param), completion: completion)
    }
    
    //MARK: - Get All Coatches list  api Call
    func getCoatchList(completion: @escaping ((Result<GetDoctorsList,APIError>) -> Void)){
        let param = [
            "AuthToken"  :  UserDefaults.userToken
        ]
        handleAPICalling(request: .getcoachList(param:param), completion: completion)
    }
    
    //MARK: -Save A paaten team  api Call
    func saveAPatternPlusTeam(SK:String = "",DoctorId:String = "",DoctorName:String = "",CoachId:String = "",CoachName:String = "",Country:String = "",completion: @escaping ((Result<GetDoctorsList,APIError>) -> Void)){
        let param = [
            "SK"             :  SK,
            "DoctorId"       :  DoctorId,
            "DoctorName"     :  DoctorName,
            "CoachName"      :  CoachName,
            "CoachId"        :  CoachId,
            "Country"        :  Country,
            "AuthToken"      :  UserDefaults.userToken
        ]
        handleAPICalling(request: .SaveAPTeam(param: param), completion: completion)
    }
    
    //MARK: - Get user Previous Chat List
    
    func getuserPreviousChat(SenderSK:String = "",ReceiverSK:String = "",completion: @escaping ((Result<PreviousUserChat,APIError>) -> Void)){
        let param = [
            "AuthToken"             :  UserDefaults.userToken,
            "SenderSK"              :  SenderSK,
            "ReceiverSK"            :  ReceiverSK
        ]
        handleAPICalling(request: .getPreviousChat(param: param), completion: completion)
    }
    
    //MARK: - Get User Chat List
    
    func getuserChatList(completion: @escaping ((Result<GetChatList,APIError>) -> Void)){
        let param = [
            "AuthToken"             :  UserDefaults.userToken,
            "SK"                    :  UserDefaults.User?.patientInfo?.sk
        ]
        handleAPICalling(request:.getChatList(param: param as [String : Any]), completion: completion)
    }
    
    //MARK: - Upload Files to Server For Chat Purpose
    
    func uploadFilestoserver(files:UIImage?,videoUrl:URL?,FileURL:URL?,audioURL:URL?,completion: @escaping ((Result<UPloadFilesModel,APIError>) -> Void)){
        let param = [
            "AuthToken"             : UserDefaults.userToken
        ]
        handleAPICalling(request:.uploadChatFile(param: param, userImg: files, videoUrl: videoUrl, FileURL: FileURL, audioURL: audioURL), completion: completion)
    }
    
    //MARK: - Manage Notifications Settings
    
    func manageNotifications(IsNotificationOn:String = "",completion: @escaping ((Result<Basic_Model,APIError>) -> Void)){
        let param = [
            "AuthToken"             :  UserDefaults.userToken,
            "SK"                    :  UserDefaults.User?.patientInfo?.sk ?? "",
            "IsNotificationOn"      : IsNotificationOn
        ] as [String : Any]
        handleAPICalling(request:.manageNotifications(param: param), completion: completion)
    }
}

