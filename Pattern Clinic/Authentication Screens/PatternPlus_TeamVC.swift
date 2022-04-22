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
    var listArray = [DoctorCoatchDetails]()
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
        let index1 = DoctorCoatchDetails(doctorName: "Select A Pattern Plus Provider", doctor_Img:"Select A Pattern Plus Provider",flag: true,doctor_Img1: "")
        self.listArray.append(index1)
        let index2 = DoctorCoatchDetails(doctorName: "Select A Pattern Plus Coach", doctor_Img:"Select A Pattern Plus Coach",flag: true,doctor_Img1: "")
        self.listArray.append(index2)
        
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
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PatternTeam", for: indexPath) as? PatternTeam else {
            return ConnectDevice()}
        cell.selectionStyle = .none
        if self.listArray[indexPath.row].flag == true{
            cell.pick_btn.isHidden = true
            cell.pick_reacher.isHidden = true
            cell.image_client.image = UIImage(named: listArray[indexPath.row].doctor_Img ?? "")
        }else{
            if indexPath.row == 0{
                cell.pick_btn.isHidden = true
                cell.pick_reacher.isHidden = false
            }else{
                cell.pick_btn.isHidden = false
                cell.pick_reacher.isHidden = true
            }
            if listArray[indexPath.row].doctor_Img1 == ""{
                cell.image_client.image = UIImage(named: listArray[indexPath.row].doctor_Img ?? "")
            }else{
                let url = URL.init(string:listArray[indexPath.row].doctor_Img1 ?? "")
                cell.image_client.sd_setImage(with: url , placeholderImage:UIImage(named: "dummy_user"))
            }
            
        }
        cell.pick_btn.addTarget(self, action:#selector(pickdector(_:)) , for: .touchUpInside)
        cell.pick_btn.tag = indexPath.row
        cell.pick_reacher.addTarget(self, action:#selector(pickCoatch(_:)) , for: .touchUpInside)
        cell.pick_reacher.tag = indexPath.row
        let filter_info = self.listArray.filter({ (res) in
            return res.flag == false
        })
        if filter_info.count == 2{
            self.submit_btn.isHidden = false
        }else{
            self.submit_btn.isHidden = true
        }
        
        cell.title_Info.text    = listArray[indexPath.row].doctorName ?? ""
        
        return cell
    }
    
    @objc func pickdector(_ sender:UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DectorsListVC") as? DectorsListVC  else{return}
        vc.modalPresentationStyle = .custom
        vc.coatch_Closer = { [weak self] (name,image,tag)  -> Void in
            guard let self = self else {return}
            Dispatch.main{
                self.listArray[tag].doctorName = name
                self.listArray[tag].doctor_Img1 = image
                self.listArray[tag].flag = false
                self.teamTable.reloadData()
                
            }
        }
        vc.indexTag = sender.tag
        self.present(vc, animated: true, completion:nil)
    }
    
    @objc func pickCoatch(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DectorsListVC") as? DectorsListVC  else{return}
        vc.modalPresentationStyle = .custom
        vc.callback_Closer = { [weak self]  (name,image,tag) -> Void in
            guard let self = self else {return}
            Dispatch.main{
                self.listArray[tag].doctorName = name
                self.listArray[tag].flag = false
                self.listArray[tag].doctor_Img1 = image
                self.teamTable.reloadData()
                
            }
        }
        vc.indexTag = sender.tag
        self.present(vc, animated: true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  self.listArray[indexPath.row].flag == true{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DectorsListVC") as? DectorsListVC  else{return}
            vc.modalPresentationStyle = .custom
            vc.callback_Closer = { [weak self]  (name,image,tag) -> Void in
                guard let self = self else {return}
                Dispatch.main{
                    self.listArray[tag].doctorName = name
                    self.listArray[tag].flag = false
                    self.listArray[tag].doctor_Img1 = image
                    self.teamTable.reloadData()
                    
                }
            }
            vc.coatch_Closer = { [weak self] (name,image,tag)  -> Void in
                guard let self = self else {return}
                Dispatch.main{
                    self.listArray[tag].doctorName = name
                    self.listArray[tag].flag = false
                    self.listArray[tag].doctor_Img1 = image
                    self.teamTable.reloadData()
                    
                }
                
            }
            vc.indexTag = indexPath.row
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


struct DoctorCoatchDetails:Codable{
    var doctorName:String?
    var doctor_Img:String?
    var flag:Bool?
    var doctor_Img1:String?
}
