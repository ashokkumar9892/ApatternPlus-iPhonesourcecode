//
//  ContactSupportVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 18/04/22.
//

import UIKit

class ContactSupportVC: CustomiseViewController {
    @IBOutlet weak var back_View:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapgesture(view:self.back_View)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
    fileprivate func addTapgesture(view:UIView){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension ContactSupportVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageCell", for: indexPath) as! OtherMessageCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
