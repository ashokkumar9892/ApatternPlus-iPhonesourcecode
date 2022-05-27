//
//  MessageListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 11/04/22.
//

import UIKit
import WidgetKit
class MessageListVC: CustomiseViewController {
    var viewModel:SocketBaseClassVC!
    @IBOutlet weak var chatTable:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SocketBaseClassVC()
        self.setUpVM(model: self.viewModel)
        self.viewModel.getUserChatDetails()
        self.viewModel.didFinishFetch = { [weak self] in
            guard let self = self else {return}
            Dispatch.main{
                self.chatTable.reloadData()
            }
        }
    }
}
extension MessageListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.chatUserInfo?.chatlist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListcell", for: indexPath) as? MessageListcell else {
            return ConnectDevice()}
        cell.selectionStyle = .none
        let chatList = self.viewModel.chatUserInfo?.chatlist?[indexPath.row]
        cell.nameLbl.text = chatList?.name ?? ""
        cell.last_Message.text = chatList?.message ?? ""
        if chatList?.chatStatus == "InActive"{
            cell.contentView.alpha = 0.4
        }else{
            cell.contentView.alpha = 1
        }
        //        if chatList.unseencount != 0 && chatList.unseencount != nil{
        //            cell.unseenCount.isHidden = false
        //        }else{
        //            cell.unseenCount.isHidden = true
        //        }
        //        cell.unseenCount.text = "\(chatList.unseencount ?? 0)"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageVC") as? MessageVC  else{return}
        vc.userChat_Info = self.viewModel.chatUserInfo?.chatlist?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


class MessageListcell:UITableViewCell{
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var last_Message:UILabel!
    @IBOutlet weak var unseenCount:UILabel!
}
