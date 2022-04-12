//
//  MenuViewModel.swift
//  Pattern Clinic
//
//  Created by mac1 on 05/04/22.
//  Copyright © 2022 Paras. All rights reserved.
//

import Foundation
import UIKit
import KYDrawerController

class MenuViewModel :NSObject{
    var list = ["Home","Coaching Appointments", "Messages","Personal Metrics","Health Tips","My Profile","Settings"]
    weak var parentVC:MenuVC?
    override init() {
        super.init()
     
    }
}


extension MenuViewModel:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  self.parentVC?.getIndex(indexPath.row)
    }
}

extension MenuViewModel:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuCell else {
            return MenuCell()
        }
        cell.selectionStyle = .none
        cell.menu_Name.text = list[indexPath.row]
        cell.menu_Image.image = UIImage(named: list[indexPath.row])
        parentVC?.listTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        return cell
        
    }
}

class MenuCell : UITableViewCell{
    @IBOutlet weak var menu_Name: UILabel!
    @IBOutlet weak var menu_Image : UIImageView!
    @IBOutlet weak var arrow_Image : UIImageView!
    @IBOutlet weak var menu_Bar: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class MainCell : UITableViewCell{
    
}




class MenuVC_1: CustomiseViewController, UITableViewDelegate {
    enum DrawerButtons : Int {
        case Home          = 0
        case CoachingAppointments     = 1
        case Messages = 2
        case PersonalMetrics     = 3
        case HealthTips   = 4
        case MyProfile = 5
        case Settings     = 6
      
        
        var activeImage : UIImage {
            switch self {
            case .Home:
                return UIImage(named: "Home")!
            case .CoachingAppointments:
                return UIImage(named: "matches_active")!
            case .Messages:
                return UIImage(named: "matches_active")!
            case .PersonalMetrics:
                return UIImage(named: "my_friends_active")!
            case .HealthTips:
                return UIImage(named: "invitations_active")!
            case .MyProfile:
                return UIImage(named: "notifications_active")!
            case .Settings:
                return UIImage(named: "profile_active")!
           
            }
        }
        var inactiveImage : UIImage {
            switch self {
            case .Home:
                return UIImage(named: "home")!
            case .CoachingAppointments:
                return UIImage(named: "Coaching Appointments")!
            case .Messages:
                return UIImage(named: "matches")!
            case .PersonalMetrics:
                return UIImage(named: "Personal Metrics")!
            case .HealthTips:
                return UIImage(named: "HealthTips")!
            case .MyProfile:
                return UIImage(named: "MyProfile")!
            case .Settings:
                return UIImage(named: "Settings")!
           
            }
        }
        var title : String {
            switch self {
            case .Home:
                return "Home"
            case .CoachingAppointments:
                return "Coaching Appointments"
            case .Messages:
                return "Messages"
            case .PersonalMetrics:
                return "Personal Metrics"
            case .MyProfile:
                return "MyProfile"
            case .Settings:
                return "Settings"
          
            case .HealthTips:
                return "Health Tips"
            }
        }
    }
    var selectedActionType: ((_ type:DrawerButtons) -> ())?
    private var tableDataSource = [DrawerButtons]()
    private var dataSource :TableViewDataSource<DrawerCell,DrawerButtons>!
    @IBOutlet weak var userImage : UIImageView!
    @IBOutlet weak var userName  : UILabel!
    @IBOutlet weak var userEmail : UILabel!
    @IBOutlet weak var drawerTable : UITableView!
    var currentActivePage         = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDataSource = [.Home,.CoachingAppointments,.Messages,.HealthTips,.PersonalMetrics,.MyProfile,.Settings,.MyProfile]
    }
    override func viewWillAppear(_ animated: Bool) {
        updateDataSource()
    }
    override func viewDidAppear(_ animated: Bool) {
        updateDataSource()
    }
    private func updateDataSource() {
        self.dataSource = TableViewDataSource(cellIdentifier: String.init(describing: DrawerCell.self), items: self.tableDataSource) { [unowned self] cell, vm in
            if cell.tag == currentActivePage {
                cell.cellImage.image = vm.activeImage
                cell.cellTitle.textColor = UIColor(named: "lbl_blackcolour")
            }
            else {
                cell.cellImage.image = vm.inactiveImage
                cell.cellTitle.textColor = UIColor(hexString: "#ACACAC")
            }
            cell.cellTitle.text       = vm.title
        }
        self.drawerTable.dataSource = self.dataSource
        self.drawerTable.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = DrawerButtons.init(rawValue: indexPath.row) {
            if let vc = parent as? KYDrawerController {
                vc.setDrawerState(.closed, animated: true)
            }
            selectedActionType?(type)
        }
    }
}
class DrawerCell: UITableViewCell {
    @IBOutlet weak var cellImage : UIImageView!
    @IBOutlet weak var cellTitle : UILabel!
    @IBOutlet weak var lineLbl:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
