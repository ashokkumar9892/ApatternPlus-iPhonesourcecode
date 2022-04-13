//
//  PendingStatusVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 07/04/22.
//

import UIKit
import KYDrawerController

class PendingStatusVC: CustomiseViewController {
    @IBOutlet weak var submit_Btn:UIButton!
    @IBOutlet weak var statusImg:UIImageView!
    @IBOutlet weak var info_Lbl:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.statusImg.image = UIImage(named: "success_img")
            self.info_Lbl.text =  "Your profile has been approved by our team. Please get started"
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.statusImg.image = UIImage(named: "decline_img")
                self.info_Lbl.text =  "Account set up could not be completed. Please contact A Pattern Medical Clinic for support."
                self.submit_Btn.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    let storyboard = StoryBoardSelection.sharedInstance.sideMenuStoryBoard
                    guard let vc = storyboard.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController  else{return}
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            })
        })
    }
    
    @IBAction func contact_Btn(_ sender :UIButton){
        
    }
}
