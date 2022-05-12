//
//  LaunchScreenVC.swift
//  Tapp App
//
//  Created by paras on 22/05/21.
//

import UIKit
import VeepooBleSDK
import KYDrawerController


class LaunchScreenVC: CustomiseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {[weak self] in
            guard let self = self else {return}
            //            if (!UserDefaults.standard.bool(forKey: "ONBOARDING")) {
            //
            //            }else {
            //                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
            //                self.navigationController?.pushViewController(vc, animated: true)
            //            }
            if UserDefaults.UserStatus == "4"{
                let storyboard = StoryBoardSelection.sharedInstance.sideMenuStoryBoard
                guard let vc = storyboard.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController  else{return}
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialScreenVC") as? TutorialScreenVC else {return}
                self.navigationController?.pushViewController(vc, animated: true)
            }
          
        }
    }
}

