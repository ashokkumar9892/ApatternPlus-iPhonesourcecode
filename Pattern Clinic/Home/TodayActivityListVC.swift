//
//  TodayActivityListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 06/04/22.
//

import UIKit

class TodayActivityListVC: CustomiseViewController {
    @IBOutlet weak var tableheight:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableheight.constant = 340
    }

}

extension TodayActivityListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Activity_List") as? Activity_List {
            cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseStatsVC") as? ExerciseStatsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
