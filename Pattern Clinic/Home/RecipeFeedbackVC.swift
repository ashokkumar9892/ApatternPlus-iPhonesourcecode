//
//  RecipeFeedbackVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 13/04/22.
//

import UIKit

class RecipeFeedbackVC: CustomiseViewController {
    @IBOutlet weak var back_View:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapgesture(view: self.back_View)
        // Do any additional setup after loading the view.
    }
    
    fileprivate func addTapgesture(view:UIView){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
    
    
}
