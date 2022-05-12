//
//  UserDefaultExtension.swift
//  POD
//
//  Created by iOS TL on 19/01/22.
//

import Foundation

fileprivate enum DefaultKey : String {
    case hasPremium
    case HasLogIn
    case UserID
    case UserToken
    case FCMToken
    case User
    case userStatus
}
extension UserDefaults {
    fileprivate class var appSuit : UserDefaults {
        if let suit =  UserDefaults(suiteName: "POD") {
            return suit
        }
        else {
            return UserDefaults.standard
        }
    }
    
    static var hasLogin: Bool {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.bool(forKey: DefaultKey.HasLogIn.rawValue)
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.HasLogIn.rawValue)
            useDef.synchronize()
        }
    }
    static var userID: String {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.string(forKey: DefaultKey.UserID.rawValue) ?? "0"
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.UserID.rawValue)
            useDef.synchronize()
        }
    }
    static var UserStatus: String {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.string(forKey: DefaultKey.userStatus.rawValue) ?? "0"
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.userStatus.rawValue)
            useDef.synchronize()
        }
    }
    static var userToken: String {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.string(forKey: DefaultKey.UserToken.rawValue) ?? "0"
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.UserToken.rawValue)
            useDef.synchronize()
        }
    }
    static var fcmToken: String {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.string(forKey: DefaultKey.FCMToken.rawValue) ?? ""
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.FCMToken.rawValue)
            useDef.synchronize()
        }
    }
    static var hasPremium: Bool {
        get {
            let useDef = UserDefaults.appSuit
            return useDef.bool(forKey: DefaultKey.hasPremium.rawValue)
        }
        set {
            let useDef = UserDefaults.appSuit
            useDef.set(newValue, forKey: DefaultKey.hasPremium.rawValue)
            useDef.synchronize()
        }
    }
    static var User: LoginResponseModel? {
        get{
            if let decodedData = UserDefaults.standard.value(forKey: DefaultKey.User.rawValue) as? Data {
                do {
                    let info = try JSONDecoder().decode(LoginResponseModel.self, from: decodedData)
                    return info
                } catch {
                    print("Failed unarchiving user data")
                    return nil
                }
            } else {
                return nil
            }
        }
        set{
            do {
                let defaults = UserDefaults.standard
                let key = DefaultKey.User.rawValue
                let encodedData = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encodedData, forKey: key)
                defaults.synchronize()
            } catch {
                print("Failed archiving user data")
            }
        }
    }
}
