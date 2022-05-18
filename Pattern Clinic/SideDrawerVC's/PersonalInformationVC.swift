//
//  PersonalInformationVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 11/04/22.
//

import UIKit

class PersonalInformationVC: CustomiseViewController {
    @IBOutlet weak var userImg:UIImageView!
    @IBOutlet weak var userNamelbl:UILabel!
    @IBOutlet weak var emailLbl:UILabel!
    @IBOutlet weak  var countrylbl:UILabel!
    @IBOutlet weak var dobLbl:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let patient_Info = UserDefaults.User?.patientInfo{
            Dispatch.background {
                let userImg = self.base64ToImage(patient_Info.profilePic ?? "")
                Dispatch.main {
                    if userImg == nil{
                        print("Error")
                    }else{
                        self.userImg.image    = userImg
                    }
                    self.userNamelbl.text = "\(patient_Info.firstName ?? "") \(patient_Info.lastName ?? "")"
                    let country_ID =  self.locale(for:patient_Info.country ?? "")
                    self.countrylbl.text  =  country_ID
                    self.dobLbl.text      = patient_Info.dob ?? ""
                    self.emailLbl.text    = patient_Info.email ?? ""
                }
            }
        }
       
    }
    
    private func locale(for fullCountryName : String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return locales
    }
}


