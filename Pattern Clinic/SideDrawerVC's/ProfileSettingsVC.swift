//
//  ProfileSettingsVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 05/04/22.
//

import UIKit

class ProfileSettingsVC: CustomiseViewController {

    @IBOutlet weak var personal_Btn:CustomRightAndLeftImageButton!
    @IBOutlet weak var height_Btn:CustomRightAndLeftImageButton!
    @IBOutlet weak var weight_Btn:CustomRightAndLeftImageButton!
    @IBOutlet weak var team_Btn:CustomRightAndLeftImageButton!
    @IBOutlet weak var userImg:UIImageView!
    @IBOutlet weak var userNamelbl:UILabel!
    let storyBoard = StoryBoardSelection.sharedInstance.mainStoryBoard
    override func viewDidLoad() {
        super.viewDidLoad()

        Dispatch.background {
            let userImg = self.base64ToImage(UserDefaults.User?.patientInfo?.profilePic ?? "")
            Dispatch.main {
                if userImg == nil{
                    print("Error")
                }else{
                    self.userImg.image    = userImg
                }
                self.userNamelbl.text = "\(UserDefaults.User?.patientInfo?.firstName ?? "" ) \(UserDefaults.User?.patientInfo?.lastName ?? "" )"
            }
        }
    }
    
    @IBAction func personal_Info(_ sender:UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInformationVC") as? PersonalInformationVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func height_Btn(_ sender:UIButton){
        guard let vc = self.storyBoard.instantiateViewController(withIdentifier: "AddHeightVC") as? AddHeightVC else {return}
        vc.screenApper = .Edit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func weight_Btn(_ sender:UIButton){
        guard let vc = self.storyBoard.instantiateViewController(withIdentifier: "AddWeightVC") as? AddWeightVC else {return}
        vc.screenApper = .Edit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func team_Btn(_ sender:UIButton){
        guard let vc = self.storyBoard.instantiateViewController(withIdentifier: "PatternPlus_TeamVC") as? PatternPlus_TeamVC else {return}
        vc.screenApper = .Edit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logout_Btn(_ sender:UIButton){
        self.alertWithOption(title: "Are you sure you want to logout?", message: "") {
            self.logOut()
        }
    }
    
    

}
