//
//  PatternPlus_TeamVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 04/04/22.
//

import UIKit
import KYDrawerController

class PatternPlus_TeamVC: CustomiseViewController {
    @IBOutlet weak var table_Height:NSLayoutConstraint!
    @IBOutlet weak var teamTable:UITableView!
    @IBOutlet weak var submit_btn:UIButton!{
        didSet{
            self.submit_btn.isHidden = true
        }
    }
    var flag = true
    var screenApper = screenCome.Signup
    @IBOutlet weak var address_Btn:UIButton!
    var listtypes = ["Select A Pattern Plus Provider","Select A Pattern Plus Coach"]
    var doctorArray = ["Dr. Shaun Murphy","Emma Watson"]
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var headerHeight:NSLayoutConstraint!
    @IBOutlet weak var titleLbl:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        switch screenApper {
        case .Signup:
            self.headerHeight.constant = 0
            self.headerView.isHidden = true
            self.titleLbl.text = "Select A Pattern Plus Team"
        case .Edit:
            self.headerHeight.constant = 74
            self.headerView.isHidden = false
            self.titleLbl.text = ""
            self.submit_btn.isHidden = true
            self.flag = false
        }
        self.teamTable.reloadData { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.table_Height.constant = self.teamTable.contentSize.height
            }
        }
    }
    
    @IBAction func submit_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PendingStatusVC") as? PendingStatusVC  else{return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension PatternPlus_TeamVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listtypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PatternTeam", for: indexPath) as? PatternTeam else {
            return ConnectDevice()}
        cell.selectionStyle = .none
        
        if flag == false{
            cell.image_client.image = UIImage(named: doctorArray[indexPath.row])
            cell.title_Info.text    = doctorArray[indexPath.row]
            if indexPath.row == 0{
                cell.pick_btn.isHidden = true
                cell.pick_reacher.isHidden = false
            }else{
                cell.pick_btn.isHidden = false
                cell.pick_reacher.isHidden = true
            }
        }else{
            cell.image_client.image = UIImage(named: listtypes[indexPath.row])
            cell.title_Info.text    = listtypes[indexPath.row]
            cell.pick_btn.isHidden = true
            cell.pick_reacher.isHidden = true
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if flag == true{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DectorsListVC") as? DectorsListVC  else{return}
            vc.modalPresentationStyle = .custom
            vc.callback_Closer = { [weak self] in
                guard let self = self else {return}
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.submit_btn.isHidden = false
                    self.address_Btn.setTitle("Ooltewah", for: .normal)
                    self.address_Btn.setTitleColor(UIColor(named: "lbl_blackcolour"), for: .normal)
                    self.flag = false
                    self.teamTable.reloadData()
                }
                
            }
            self.present(vc, animated: true, completion:nil)
        }
    }
}


class PatternTeam:UITableViewCell{
    @IBOutlet weak var bottomView:UIView!
    @IBOutlet weak var image_client:UIImageView!
    @IBOutlet weak var title_Info:UILabel!
    @IBOutlet weak var pick_btn:UIButton!{
        didSet{
            self.pick_btn.underline()
        }
    }
    @IBOutlet weak var pick_reacher:UIButton!{
        didSet{
            self.pick_reacher.underline()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.perform(#selector(updateUI), with: nil, afterDelay: 0)
    }
    
    @objc func updateUI() {
        self.bottomView.applyGradient(colours: [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)], locations: [0.1, 1])
    }
    
}
