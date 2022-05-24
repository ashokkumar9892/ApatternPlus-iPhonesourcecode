//
//  RegistrationModels.swift
//  Muselink
//
//  Created by HarishParas on 18/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import Foundation

// MARK: - LoginResponseModel
struct LoginResponseModel: APIModel {
    let authToken: String?
    var patientInfo: PatientInfo?
    let response: Int?
    let errorMessage: String?
}

struct PatientInfo: Codable {
    let profilePic: String?
    var gender:String?
    let userName, firstName, lastName, email: String?
    let country,dob,referAs,weight: String?
    let height, sk: String?
}


struct Basic_Model:APIModel{
    var response: Int?
    var errorMessage: String?
}


struct CountiesWithPhoneModel {
    var dial_code :String?
    var countryName : String?
    var code :String?
}

struct CityCodable:Codable {
    var id, name :String?
}


// MARK: - GetDoctorsList
struct GetDoctorsList: APIModel {
    let doctorInfo: [DoctorInfo]?
    let response: Int?
    let errorMessage: String?
}

// MARK: - DoctorInfo
struct DoctorInfo: Codable {
    let designation: String?
    let userName: String?
    let profileImage: String?
    let sk: String?
}

// MARK: - PreviousUserChat
struct PreviousUserChat: APIModel {
    var response: Int?
    var errorMessage: String?
    var chatlist: [Chatlist]
}

// MARK: - User Chatlist _Info
struct Chatlist: Codable {
    //  let connectionID, authToken, chatID, receiverID: JSONNull?
    let senderID,receiverId: String?
    let sentOn: String?
    //   let messageOn, receiverImage, senderImage: JSONNull?
    let message: String?
    let chatType: String?
    let isAdmin, isNotification: Bool?
    //   let toIsRead, fromIsRead: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        //   case connectionID = "connectionId"
        //  case authToken
        //case chatID = "chatId"
        case receiverId,chatType
        case senderID = "senderId"
        //toIsRead, fromIsRead,chatType,totalBill,receiverImage, senderImage,messageOn
        case sentOn, message, isAdmin, isNotification
    }
}


// MARK: - PreviousUserChat
struct GetChatList: APIModel {
    let chatlist: [RecentChatlist]?
    let response: Int?
    let errorMessage: String?
}

// MARK: - Chatlist
struct RecentChatlist: Codable {
    let profilePic, name, sk,message,chatStatus: String?
    let isAdmin, isNotification: Bool?

    enum CodingKeys: String, CodingKey {
        case profilePic, name, sk,message,chatStatus
        case isAdmin, isNotification
    }
}



struct UPloadFilesModel:APIModel{
    var response: Int?
    var errorMessage: String?
    var imageurls:[UplaodfilesURL]?
    
}

struct UplaodfilesURL:Codable{
    var files:String?
    var filetype:String?
}
