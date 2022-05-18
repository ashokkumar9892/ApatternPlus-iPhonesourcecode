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
    case Signup(param:[String:Any])
    case logIn(param:[String:Any])
    case verifyOTP(param:[String:Any])
    case forgetPassword(param:[String:Any])
    case createProfile(param:[String:Any])
    case getDectorList(param:[String:Any])
    case getcoachList(param:[String:Any])
    case resetPasswordApi(param:[String:Any])
    case GetUserProfile(param:[String:Any])
    case SaveAPTeam(param:[String:Any])
    case getPreviousChat(param:[String:Any])
    case getChatList(param:[String:Any])
    case uploadChatFile(param:[String:Any],userImg:UIImage?,videoUrl:URL?,FileURL:URL?,audioURL:URL?)
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
        case .Signup:
            return "Cognito/CognitoUser"
        case .logIn:
            return "Basic/Login"
        case .verifyOTP:
            return "Cognito/ConfirmOTP"
        case .forgetPassword:
            return "Basic/ForgotPassword"
        case .createProfile:
            return "Basic/UpdateProfile"
        case .getDectorList:
            return "Basic/DoctorsList"
        case .getcoachList:
            return "Basic/CoachList"
        case .resetPasswordApi:
            return "Basic/ResetPassword"
        case .GetUserProfile:
            return "GetUserProfile"
        case .SaveAPTeam:
            return "Basic/SelectAPTeam"
        case .getPreviousChat:
            return "Chat/MyChat"
        case .getChatList:
            return "Chat/ChatUsers"
        case .uploadChatFile:
            return "Chat/UploadFiles"
        }
    }
    var httpMethod: HTTPMethod {
        return .post
    }
    var task: HTTPTask {
        switch self {
            // Registration
        case .Signup(param: let param):
            return .requestParametersAndHeaders(bodyParameters:param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders:headers)
        case .logIn(param: let param):
            return .requestParametersAndHeaders(bodyParameters:param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders:headers)
        case .verifyOTP(param: let param):
            return .requestParametersAndHeaders(bodyParameters:param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders:headers)
        case .forgetPassword(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders:headers)
        case .createProfile(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
        case .getDectorList(param : let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
        case .getcoachList(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders:headers)
        case .resetPasswordApi(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders:headers)
        case .GetUserProfile(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders:headers)
        case .SaveAPTeam(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders:headers)
        case .getPreviousChat(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders:headers)
        case .getChatList(param: let param):
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders:headers)
        case .uploadChatFile(param:  let param, userImg: let userfile, videoUrl:  let videoURL, FileURL: let fileURL, audioURL: let audioURL):
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            let boundry = self.createBodyWithParameters(parameters: param, filePathKey: "files", imageDataKey: userfile, boundary: boundary as String, videoUrl: videoURL, fileUrl: fileURL,audioURL:audioURL)
            return .requestMultipart(data: boundry, additionHeaders: headers)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .logIn,.forgetPassword,.resetPasswordApi:
            return nil
        case .uploadChatFile:
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            return ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
        default:
            return ["Content-Type":NetworkManager.contentType]
        }
    }
}


extension APIEndPoint{
    func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: UIImage?, boundary: String,videoUrl:URL?,fileUrl:URL?,audioURL:URL?) -> Data {
        var body = Data();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        let boundaryPrefix = "--\(boundary)\r\n"
        if let image = imageDataKey {
            let filename = "user-profile.jpg"
            
            let mimetype = "image/jpg"
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image.jpegData(compressionQuality: 1)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        }
        if let video = videoUrl{
            
            let filename = "\(Date().timeIntervalSince1970).\(video.absoluteURL.pathExtension)"
            body.append(string: boundaryPrefix)
            body.append(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            if filename.lowercased() == "mov"{
                body.append(string: "Content-Type: video/quicktime\r\n\r\n")
            }
            else{
                body.append(string: "Content-Type: video/mp4\r\n\r\n")
            }
            let data = try? Data.init(contentsOf:video)
            body.append(data ?? Data())
            body.append(string: "\r\n")
        }
        
        if let file_upload = fileUrl{
            let filename = "Thiru.pdf"
            let mimetype = "application/pdf"
            var dataFile: Data = Data()
            dataFile = NSData(contentsOf: file_upload)! as Data
            body.append(string: "--\(boundary)\r\n")
            body.append(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.append(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(dataFile as Data)
            body.append(string: "\r\n")
        }
        if let audio_URLFile = audioURL{
            let filename = "\(Date().timeIntervalSince1970).\(audio_URLFile.absoluteURL.pathExtension)"
            body.append(string: boundaryPrefix)
            body.append(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            if filename.lowercased() == "mov"{
                body.append(string: "Content-Type: video/quicktime\r\n\r\n")
            }
            else{
                body.append(string: "Content-Type: video/mp3\r\n\r\n")
            }
            let data = try? Data.init(contentsOf:audio_URLFile)
            body.append(data ?? Data())
            body.append(string: "\r\n")
        }
        
        body.append( string: "--\(boundary)--\r\n")
        return body
    }
}

extension Data {
    mutating func append(string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}

