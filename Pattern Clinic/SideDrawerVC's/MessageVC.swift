//
//  MessageVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 11/04/22.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation

class MessageVC: CustomiseViewController {
    var viewModel:SocketBaseClassVC!
    @IBOutlet weak var chatTable:UITableView!
    @IBOutlet weak var txt_message:UITextView!
    var userChat_Info:RecentChatlist?
    var userChat = [Chatlist]()
    var fontCamera    = false
    var images        = [String:Any]()
    var pickedImage   : UIImage?
    var videoURl       :URL?
    var fileURL        :URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel  = SocketBaseClassVC()
        self.setUpVM(model: self.viewModel)
        self.viewModel.makeSocketConnection()
        self.viewModel.ReceiverSK.value = userChat_Info?.sk ?? ""
        self.viewModel.SenderSK.value = UserDefaults.User?.patientInfo?.sk ?? ""
        
        self.viewModel.socketConnectCloser = { [weak self] in
            guard let self = self else {return}
            Dispatch.main{
                self.viewModel.getprevious_Chat()
            }
        }
        
        self.viewModel.didFinishFetch = { [weak self] in
            guard let self = self else {return}
            Dispatch.main{
                self.txt_message.text = ""
                self.chatTable.reloadData()
                let indexPath = IndexPath(row:(self.viewModel?.userPreviousChat?.chatlist.count ?? 0)-1, section: 0)
                self.chatTable.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
            
        }
        
    }
    
    @IBAction func openCamera(_ sender :UIButton){
        ImagePickerController.init().pickImage(self, isCamraFront: fontCamera, isvideoFlag: true) { [weak self] (videoURL) in
            guard let self = self else {return}
            Dispatch.main{
                self.viewModel.uploadFilesToServer(files:self.pickedImage,videoUrl: videoURL, FileURL:self.fileURL)
            }
        } _: { [weak self] (img) in
            guard let self = self else {return}
            Dispatch.main{
                self.pickedImage = img
                self.images["identity_img"] = img
                self.viewModel.uploadFilesToServer(files:img,videoUrl:self.videoURl,FileURL:self.fileURL)
            }
        }
    }
    
    @IBAction func openDocumentPicker(){
        let importMenu = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", kUTTypePDF as String], in: UIDocumentPickerMode.import)
        importMenu.delegate = self
        self.present(importMenu, animated: true, completion: nil)
    }
    
    @IBAction func send_Message(_ sender :UIButton){
        if self.txt_message.text != "" || self.txt_message.text == " " {
            self.viewModel.userMessage.value = txt_message.text ??  ""
            self.viewModel.sendMessageToUser()
        }
    }
}


// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension MessageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.userPreviousChat?.chatlist.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].senderID == UserDefaults.User?.patientInfo?.sk ?? ""{
            if self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Image" || self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Video"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageVideoCell", for: indexPath) as! ImageVideoCell
                if self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Image"{
                    cell.play_btn.isHidden = true
                }else{
                    cell.play_btn.isHidden = false
                }
                let url = URL.init(string:self.viewModel?.userPreviousChat?.chatlist.reversed()[indexPath.row].message ?? "")
                cell.user_Img.sd_setImage(with:url, placeholderImage:UIImage(named: "dummy_user"))
                cell.play_btn.addTarget(self, action: #selector(play_VideoLink(_ :)), for: .touchUpInside)
                cell.play_btn.tag = indexPath.row
                return cell
            }else if self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Text"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
                cell.msgLbl.text = self.viewModel?.userPreviousChat?.chatlist.reversed()[indexPath.row].message ?? ""
                let time = self.convertDateFormate(dateString: self.viewModel?.userPreviousChat?.chatlist.reversed()[indexPath.row].sentOn ?? "")
                cell.timeLbl.text = time
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocmentmyCell", for: indexPath) as! DocmentmyCell
                return cell
            }
            
        } else {
            if self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Image" || self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Video"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherImageCell", for: indexPath) as! OtherImageCell
                if self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Image"{
                    cell.play_btn.isHidden = true
                }else{
                    cell.play_btn.isHidden = false
                }
                let url = URL.init(string:self.viewModel?.userPreviousChat?.chatlist.reversed()[indexPath.row].message ?? "")
                cell.user_Img.sd_setImage(with:url, placeholderImage:UIImage(named: "dummy_user"))
                cell.play_btn.addTarget(self, action: #selector(play_VideoLink(_ :)), for: .touchUpInside)
                cell.play_btn.tag = indexPath.row
                return cell
            }else if self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Text"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageCell", for: indexPath) as! OtherMessageCell
                cell.msgLbl.text = self.viewModel?.userPreviousChat?.chatlist.reversed()[indexPath.row].message ?? ""
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Docmentanotheruser", for: indexPath) as! Docmentanotheruser
                return cell
            }
        }
    }
    
    @objc func play_VideoLink(_ sender :UIButton){
        self.playVideo(videoLink: self.viewModel.userPreviousChat?.chatlist.reversed()[sender.tag].message ?? "")
    }
    
    func playVideo(videoLink:String){
        let videoURL = URL(string: videoLink)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
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

// MARK:- OTHER MESSAGE TABLE CELL
class OtherImageCell: UITableViewCell {
    @IBOutlet weak var user_Img:UIImageView!
    @IBOutlet weak var play_btn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class ImageVideoCell:UITableViewCell{
    @IBOutlet weak var user_Img:UIImageView!
    @IBOutlet weak var play_btn:UIButton!
}

class DocmentmyCell:UITableViewCell{
    @IBOutlet weak var user_Img:UIImageView!
    @IBOutlet weak var play_btn:UIButton!
}

class Docmentanotheruser:UITableViewCell{
    @IBOutlet weak var user_Img:UIImageView!
    @IBOutlet weak var play_btn:UIButton!
}
extension MessageVC:UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.viewModel.uploadFilesToServer(files:self.pickedImage,videoUrl:self.videoURl,FileURL:url)
    }
}



extension Data{
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
