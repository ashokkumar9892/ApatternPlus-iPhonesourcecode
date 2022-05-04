//
//  MessageListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 11/04/22.
//

import UIKit

class MessageListVC: CustomiseViewController {
    var viewModel:SocketBaseClassVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SocketBaseClassVC()
        self.setUpVM(model: self.viewModel)
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.makeSocketConnection()
        self.viewModel.socketConnectCloser = { [weak self] in
            guard let self = self else {return}
            Dispatch.main{
                self.viewModel.getUserChatDetails()
            }
            
        }
        
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
