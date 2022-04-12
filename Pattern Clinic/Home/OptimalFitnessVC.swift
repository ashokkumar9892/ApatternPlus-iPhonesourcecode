//
//  OptimalFitnessVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 06/04/22.
//

import UIKit

class OptimalFitnessVC: CustomiseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

extension OptimalFitnessVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OptimalCell") as? OptimalCell {
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
}


class OptimalCell:UITableViewCell{
    
}
