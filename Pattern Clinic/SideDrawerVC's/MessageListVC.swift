//
//  MessageListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 11/04/22.
//

import UIKit

class MessageListVC: CustomiseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}


extension MessageListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListcell", for: indexPath) as? MessageListcell else {
            return ConnectDevice()}
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageVC") as? MessageVC  else{return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


class MessageListcell:UITableViewCell{
    
}
