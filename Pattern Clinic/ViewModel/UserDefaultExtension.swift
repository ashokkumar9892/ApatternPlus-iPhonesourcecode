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
}
