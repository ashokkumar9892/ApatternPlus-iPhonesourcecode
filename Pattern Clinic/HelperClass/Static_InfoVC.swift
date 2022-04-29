//
//  Static_InfoVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 04/04/22.
//

import UIKit

class Static_InfoVC: NSObject {
    static let sharedInstance = Static_InfoVC()
    var device_List = [Device_Info]()
    func allDevice_Info(actionClosure: @escaping () -> Void){
        self.device_List.removeAll()
        let device_1 = Device_Info(device_name: "Watch", image: UIImage(named: "watch"), flag: true)
        self.device_List.append(device_1)
//        let device_2 = Device_Info(device_name: "Scale", image: UIImage(named: "scale"), flag: true)
//        self.device_List.append(device_2)
//        let device_3 = Device_Info(device_name: "Blood Pressure", image: UIImage(named: "blood_pressure"), flag: true)
//        self.device_List.append(device_3)
//        let device_4 = Device_Info(device_name: "Blood Glucose", image: UIImage(named: "glucose_device"), flag: true)
//        self.device_List.append(device_4)
        actionClosure()
    }
}
