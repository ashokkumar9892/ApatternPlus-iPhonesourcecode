//
//  NutritionTrackingVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 07/04/22.
//

import UIKit

class NutritionTrackingVC: CustomiseViewController {
    @IBOutlet weak var tableheight:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableheight.constant = 450
    }
    

}

extension NutritionTrackingVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionTrackingCell") as? NutritionTrackingCell {
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsVC") as? RecipeDetailsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

class NutritionTrackingCell:UITableViewCell{
    
}
