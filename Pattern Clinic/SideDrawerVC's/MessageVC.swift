//
//  MessageVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 11/04/22.
//

import UIKit

class MessageVC: CustomiseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
}
// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension MessageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageCell", for: indexPath) as! OtherMessageCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK:- MY MESSAGE TABLE CELL
class MyMessageCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}


// MARK:- OTHER MESSAGE TABLE CELL
class OtherMessageCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var userImgView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
