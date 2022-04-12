//
//  CreateProfileVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit

class CreateProfileVC: CustomiseViewController {
    @IBOutlet weak var support_Btn:UIButton!{
        didSet{
            self.support_Btn.underline()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func next_Btn(_ sender:UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddWeightVC") as? AddWeightVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
