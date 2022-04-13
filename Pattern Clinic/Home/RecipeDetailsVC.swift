//
//  RecipeDetailsVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 07/04/22.
//

import UIKit

class RecipeDetailsVC: CustomiseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func complete_Btn(_ sender :UIButton){
        guard let vc = StoryBoardSelection.sharedInstance.healthStoryBoard.instantiateViewController(withIdentifier: "RecipeFeedbackVC") as? RecipeFeedbackVC  else{return}
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion:nil)
    }
    
}
