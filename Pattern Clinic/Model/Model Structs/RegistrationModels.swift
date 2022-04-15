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
    let patientInfo: PatientInfo?
    let response: Int?
    let errorMessage: String?
}

struct PatientInfo: Codable {
    let profilePic: String?
    let userName, firstName, lastName, email: String
    let country: String?
    let height, weight, sk: String
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
