//
//  SettingsViewModel.swift
//  Pattern Clinic
//
//  Created by mac1 on 26/05/22.
//

import UIKit

class SettingsViewModel: NSObject,ViewModel{
    enum ModelType {
        case ManageNotifications
       
    }
    var modelType         : ModelType
    var brokenRules       : [BrokenRule]    = [BrokenRule]()
    var notificationFlag  : Dynamic<String> = Dynamic("")
   
    
    private var emailCode : String          = ""
    var isValid           : Bool {
        get {
            self.brokenRules = [BrokenRule]()
          //  self.Validate()
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
    var showText = "Please Wait..."
}

extension SettingsViewModel{
    func manageNotifications(){
        Indicator.shared.show(showText)
        let model = NetworkManager.sharedInstance
        model.manageNotifications(IsNotificationOn:notificationFlag.value) { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success( _ ):
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
}
