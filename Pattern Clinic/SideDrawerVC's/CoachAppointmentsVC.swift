//
//  CoachAppointmentsVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 12/04/22.
//

import UIKit

class CoachAppointmentsVC: CustomiseViewController {
    @IBOutlet var segmentedControl: UISegmentedControl!{
        didSet{
            segmentedControl.backgroundColor = .white
            segmentedControl.tintColor = .clear
        }
    }
    @IBOutlet weak var tableheight:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Outfit-Regular", size: 14.0)!, NSAttributedString.Key.foregroundColor:UIColor(hexString: "#787878")], for: .normal)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Outfit-Medium", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor(hexString: "#101010")], for: .selected)
        self.tableheight.constant = 260
        
    }
    
    
}


extension CoachAppointmentsVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Activity_List") as? Activity_List {
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CoachProfileVC") as? CoachProfileVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
