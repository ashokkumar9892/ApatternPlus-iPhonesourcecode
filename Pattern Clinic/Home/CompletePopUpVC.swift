//
//  CompletePopUpVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 13/04/22.
//

import UIKit

class CompletePopUpVC: CustomiseViewController {
    @IBOutlet weak var textFieldStack:UIStackView!{
        didSet{
            self.textFieldStack.isHidden = true
        }
    }
    @IBOutlet weak var yes_Btn:UIButton!
    @IBOutlet weak var no_Btn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func radio_Btn(_ sender :UIButton){
        if sender.tag == 1{
            yes_Btn.setImage(UIImage(named: "radio_on"), for: .normal)
            no_Btn.setImage(UIImage(named: "radio_off"), for: .normal)
            textFieldStack.isHidden = true
        }else{
            yes_Btn.setImage(UIImage(named: "radio_off"), for: .normal)
            no_Btn.setImage(UIImage(named: "radio_on"), for: .normal)
            textFieldStack.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
}
