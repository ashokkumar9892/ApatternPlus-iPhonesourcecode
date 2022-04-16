//
//  APIEndPoint.swift
//  OMDA(Driver app)
//
//  Created by MAC on 17/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

enum NetworkEnvironment : String {
    case development  = "http://patternclinicapis.harishparas.com/api/"
}

//enum OtherURLS:String {
//    
//}
enum APIEndPoint {
    // Registraton
    case logIn(param:[String:Any])
    case forgetPassword(param:[String:Any])
    case createProfile(param:[String:Any])
    case getDectorList(param:[String:Any])
    case getcoachList(param:[String:Any])
    
}
extension APIEndPoint:EndPointType {
    var environmentBaseURL : String {
        return NetworkManager.environment.rawValue
    }
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    var path: String {
        switch  self {
            // Registration
        case .logIn:
            return "Basic/Login"
        case .forgetPassword:
            return "Basic/ForgotPassword"
        case .createProfile:
            return "Basic/UpdateProfile"
        case .getDectorList:
            return "Basic/DoctorsList"
        case .getcoachList:
            return "Basic/CoachList"
            
        }
    }
    var httpMethod: HTTPMethod {
        return .post
    }
    var task: HTTPTask {
        switch self {
            // Registration
        case .logIn(param: let param):
            return .requestParametersAndHeaders(bodyParameters:param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .forgetPassword(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .createProfile(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .getDectorList(param : let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
        case .getcoachList(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: ["Content-Type":NetworkManager.contentType])
            
        }
    }
    var headers: HTTPHeaders? {
        return nil
    }
}