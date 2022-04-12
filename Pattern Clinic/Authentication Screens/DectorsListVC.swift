//
//  DectorsListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 06/04/22.
//

import UIKit

class DectorsListVC: UIViewController {
    var callback_Closer:(() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

extension DectorsListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Doctors_InfoList") as? Doctors_InfoList {
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.callback_Closer?()
        self.dismiss(animated: true, completion: nil)
    }
    
}

class Doctors_InfoList:UITableViewCell{
    
}
