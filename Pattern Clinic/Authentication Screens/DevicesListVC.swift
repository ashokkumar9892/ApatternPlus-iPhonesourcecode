//
//  DevicesListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//
import UIKit
import IBAnimatable

class DevicesListVC: CustomiseViewController {
    @IBOutlet weak var tableHeight:NSLayoutConstraint!
    var device_List = [Device_Info]()
    @IBOutlet weak var device_table:UITableView!
    @IBOutlet weak var submit_btn:UIButton!{
        didSet{
            self.submit_btn.backgroundColor = UIColor(named:"blue_Back")
            self.submit_btn.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var support_Btn:UIButton!{
        didSet{
            self.support_Btn.underline()
        }
    }
    var screenApper = screenCome.Signup
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var hideView:UIView!
    @IBOutlet weak var instractionLbl:UILabel!
    var selectedIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableHeight.constant = 4*118
        
        Static_InfoVC.sharedInstance.allDevice_Info { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.device_List = Static_InfoVC.sharedInstance.device_List
                self.device_table.reloadData()
            }
        }
        
        switch screenApper {
        case .Signup:
            self.headerView.isHidden     = true
            self.instractionLbl.isHidden = false
            self.hideView.isHidden       = false
        case .Edit:
            self.headerView.isHidden     = false
            self.instractionLbl.isHidden = true
            self.support_Btn.isHidden    = true
            self.submit_btn.isHidden     = true
            self.hideView.isHidden       = true
            self.selectedIndex = 0
        }
    }
    
    @IBAction func submit_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PatternPlus_TeamVC") as? PatternPlus_TeamVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
}

extension DevicesListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.device_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectDevice", for: indexPath) as? ConnectDevice else {
            return ConnectDevice()}
        cell.selectionStyle = .none
        if self.device_List[indexPath.row].flag == false || indexPath.row == selectedIndex{
            cell.backView.borderColor = UIColor(hexString: "#0000EE")
            self.device_List[indexPath.row].flag = true
            cell.backView.borderWidth = 1
        }else{
            cell.backView.borderColor = UIColor(hexString: "#ECECEC")
            cell.backView.borderWidth = 1
        }
        cell.device_Img.image = self.device_List[indexPath.row].image
        cell.device_name.text = self.device_List[indexPath.row].device_name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            switch screenApper {
            case .Signup:
                self.device_List[indexPath.row].flag = false
                self.device_table.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WatchConnectscucessPopVC") as? WatchConnectscucessPopVC else {return}
                    vc.callBack_info = { [weak self] in
                        guard let self = self else {return}
                        Dispatch.main{
                            self.submit_btn.backgroundColor = UIColor(named:"button_Colour")
                            self.submit_btn.isUserInteractionEnabled = true
                        }
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            case .Edit:
                break
            }
        }
    }
}

class ConnectDevice:UITableViewCell{
    @IBOutlet weak var backView:AnimatableView!
    @IBOutlet weak var device_Img:UIImageView!
    @IBOutlet weak var device_name:UILabel!
    
    
}


struct Device_Info{
    var device_name:String?
    var image:UIImage?
    var flag : Bool?
}
