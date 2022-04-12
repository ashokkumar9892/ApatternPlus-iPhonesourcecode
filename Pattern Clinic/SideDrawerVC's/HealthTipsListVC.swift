//
//  HealthTipsListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 12/04/22.
//

import UIKit

class HealthTipsListVC: CustomiseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

extension HealthTipsListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TipsList", for: indexPath) as? TipsList else {
            return TipsList()}
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HealthTipDetailsVC") as? HealthTipDetailsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


class TipsList:UITableViewCell{
    
}
