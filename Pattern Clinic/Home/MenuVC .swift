//
//  MenuVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 05/04/22.
//

import UIKit
import KYDrawerController

class MenuVC: CustomiseViewController {
    @IBOutlet weak var listTable:UITableView!
    @IBOutlet weak var listTableheight:NSLayoutConstraint!
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
                return UIImage(named: "home_active")!
            case .CoachingAppointments:
                return UIImage(named: "appointment_active")!
            case .Messages:
                return UIImage(named: "messages_active")!
            case .PersonalMetrics:
                return UIImage(named: "metrics_active")!
            case .HealthTips:
                return UIImage(named: "health_active")!
            case .MyProfile:
                return UIImage(named: "profile_active")!
            case .Settings:
                return UIImage(named: "settings_active")!
                
            }
        }
        var inactiveImage : UIImage {
            switch self {
            case .Home:
                return UIImage(named: "Home")!
            case .CoachingAppointments:
                return UIImage(named: "Coaching Appointments")!
            case .Messages:
                return UIImage(named: "Messages")!
            case .PersonalMetrics:
                return UIImage(named: "Personal Metrics")!
            case .HealthTips:
                return UIImage(named: "Health Tips")!
            case .MyProfile:
                return UIImage(named: "My Profile")!
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
                return "My Profile"
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
    var currentActivePage         = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDataSource = [.Home,.CoachingAppointments,.Messages,.PersonalMetrics,.HealthTips,.MyProfile,.Settings]
        self.listTableheight.constant = 500
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
                cell.lineLbl.isHidden = false
                cell.cellImage.image = vm.activeImage
                cell.cellTitle.font = UIFont(name: "Outfit-Medium", size: 16.0)
                cell.cellTitle.textColor = UIColor(named: "lbl_blackcolour")
            }
            else {
                cell.lineLbl.isHidden = true
                cell.cellImage.image = vm.inactiveImage
                cell.cellTitle.font = UIFont(name: "Outfit-Light", size: 16.0)
                cell.cellTitle.textColor = UIColor(hexString: "#ACACAC")
            }
            cell.cellTitle.text       = vm.title
        }
        self.listTable.dataSource = self.dataSource
        self.listTable.delegate   = self
        self.listTable.reloadData()
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

extension MenuVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
