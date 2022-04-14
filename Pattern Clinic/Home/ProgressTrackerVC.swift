//
//  ProgressTrackerVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 13/04/22.
//

import UIKit

class ProgressTrackerVC: CustomiseViewController {
    var itemsArray = ["Adequate Sunlight","Plenty Of Water","Air","Trust In Divine Power","Temperance","Exercise","Rest","Nutrition"]
    var percentArray = ["90%","80%","20%","50%","70%","80%","70%","60%"]
    override func viewDidLoad() {
        super.viewDidLoad()


    }

}

extension ProgressTrackerVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerCell") as? TrackerCell {
            cell.selectionStyle = .none
            cell.track_Name.text = self.itemsArray[indexPath.row]
            cell.track_Img.image = UIImage(named: self.itemsArray[indexPath.row])
            cell.perLbl.text = percentArray[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}


class TrackerCell:UITableViewCell{
    @IBOutlet weak var track_Img:UIImageView!
    @IBOutlet weak var track_Name:UILabel!
    @IBOutlet weak var perLbl:UILabel!
}
