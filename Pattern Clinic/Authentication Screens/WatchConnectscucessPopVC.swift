//
//  WatchConnectscucessPopVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 04/04/22.
//

import UIKit

class WatchConnectscucessPopVC: CustomiseViewController {
    @IBOutlet weak var watchImg:UIImageView!
    @IBOutlet weak var info_Lbl:UILabel!
    var callBack_info:(() -> ())?
    var connectionFlag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        if !connectionFlag{
            self.watchImg.image = UIImage(named: "watch_disconnected")
            self.info_Lbl.text =  "Watch is not successfully connected."
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.callBack_info?()
            self.navigationController?.popViewController(animated: true)
        })
    }
}
