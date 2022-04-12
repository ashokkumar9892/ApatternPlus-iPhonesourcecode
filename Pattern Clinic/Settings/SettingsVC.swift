//
//  SettingsVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 11/04/22.
//

import UIKit

class SettingsVC: CustomiseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func contactUs_btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUSVC") as? ContactUSVC  else{return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func device_List(_ sender :UIButton){
        guard let vc = StoryBoardSelection.sharedInstance.mainStoryBoard.instantiateViewController(withIdentifier: "DevicesListVC") as? DevicesListVC  else{return}
        vc.screenApper = .Edit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changePassword_btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC  else{return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func aboutus_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as? AboutUsVC  else{return}
        vc.tag = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
