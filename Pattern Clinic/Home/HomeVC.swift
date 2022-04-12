//
//  HomeVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 05/04/22.
//

import UIKit

class HomeVC: CustomiseViewController {
    @IBOutlet weak var tableheight:NSLayoutConstraint!
    @IBOutlet weak var viewall_btn:UIButton!{
        didSet{
            self.viewall_btn.underline()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableheight.constant = 260
    }
    
    @IBAction func viewAll_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TodayActivityListVC") as? TodayActivityListVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    @IBAction func accountability_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrendsVC") as? TrendsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func optimal_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptimalFitnessVC") as? OptimalFitnessVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tracking_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NutritionTrackingVC") as? NutritionTrackingVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension HomeVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Activity_List") as? Activity_List {
            cell.selectionStyle = .none
            if indexPath.row == 0{
                cell.complete_Btn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
                cell.complete_Btn.setTitle("Completed", for: .normal)
                cell.complete_Btn.backgroundColor = UIColor(hexString: "#00BE59")
                
            }else{
                cell.complete_Btn.setTitleColor(UIColor(hexString: "#787878"), for: .normal)
                cell.complete_Btn.setTitle("Complete", for: .normal)
                cell.complete_Btn.backgroundColor = UIColor(hexString: "#EFEFEF")
            }
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseStatsVC") as? ExerciseStatsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


class Activity_List:UITableViewCell{
    @IBOutlet weak var complete_Btn:UIButton!
}
