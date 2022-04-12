//
//  AboutUsVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 11/04/22.
//

import UIKit

class AboutUsVC: CustomiseViewController {
    var tag:Int?
    @IBOutlet weak var titleLbl:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if tag == 1{
            self.titleLbl.text = "About Us"
        }else{
            self.titleLbl.text = "Terms & Policies"
        }
    }
    


}
