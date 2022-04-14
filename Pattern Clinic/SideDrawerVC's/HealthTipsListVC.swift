//
//  HealthTipsListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 12/04/22.
//

import UIKit

class HealthTipsListVC: CustomiseViewController {
    var imgArray = ["dummy_food","dummy_running"]
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
        cell.bg_Img.image = UIImage(named: imgArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HealthTipDetailsVC") as? HealthTipDetailsVC else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HealthTripdetails1VC") as? HealthTripdetails1VC else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}


class TipsList:UITableViewCell{
    @IBOutlet weak var bg_Img:UIImageView!
}
