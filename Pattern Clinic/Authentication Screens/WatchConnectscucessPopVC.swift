//
//  WatchConnectscucessPopVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 04/04/22.
//

import UIKit

class WatchConnectscucessPopVC: UIViewController {
    @IBOutlet weak var watchImg:UIImageView!
    @IBOutlet weak var info_Lbl:UILabel!
    var callBack_info:(() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(1.5)), execute: {
            self.watchImg.image = UIImage(named: "watch_disconnected")
            self.info_Lbl.text =  "Watch is not successfully connected."
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.callBack_info?()
                self.navigationController?.popViewController(animated: true)
            })
        })
    }
    
}
