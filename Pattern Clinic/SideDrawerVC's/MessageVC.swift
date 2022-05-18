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
import SafariServices
import iRecordView

class MessageVC: CustomiseViewController {
    
    let mpRecorder: MPAudioRecorder = MPAudioRecorder()
    var viewModel:SocketBaseClassVC!
    @IBOutlet weak var chatTable:UITableView!
    @IBOutlet weak var txt_message:UITextView!
    var userChat_Info:RecentChatlist?
    var userChat = [Chatlist]()
    var fontCamera    = false
    var images        = [String:Any]()
    var pickedImage    : UIImage?
    var videoURl       :URL?
    var fileURL        :URL?
    var audioURL       :URL?
    
    @IBOutlet weak var record_View: RecordView!
    @IBOutlet weak var record_BTN: RecordButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel  = SocketBaseClassVC()
        self.setUpVM(model: self.viewModel)
        self.viewModel.makeSocketConnection()
        self.viewModel.ReceiverSK.value = userChat_Info?.sk ?? ""
        self.viewModel.SenderSK.value = UserDefaults.User?.patientInfo?.sk ?? ""
        record_BTN.recordView = record_View
        record_View.delegate = self
        mpRecorder.delegateMPAR  = self
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
                if self.viewModel?.userPreviousChat?.chatlist.count ?? 0 != 0{
                    let indexPath = IndexPath(row:(self.viewModel?.userPreviousChat?.chatlist.count ?? 0)-1, section: 0)
                    self.chatTable.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            }
            
        }
        
    }
    
    @IBAction func openCamera(_ sender :UIButton){
        ImagePickerController.init().pickImage(self, isCamraFront: fontCamera, isvideoFlag: true) { [weak self] (videoURL) in
            guard let self = self else {return}
            Dispatch.main{
                self.viewModel.uploadFilesToServer(files:self.pickedImage,videoUrl: videoURL, FileURL:self.fileURL, audioURL: self.audioURL)
            }
        } _: { [weak self] (img) in
            guard let self = self else {return}
            Dispatch.main{
                self.pickedImage = img
                self.images["identity_img"] = img
                self.viewModel.uploadFilesToServer(files:img,videoUrl:self.videoURl,FileURL:self.fileURL, audioURL: self.audioURL)
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
                cell.selectionStyle = .none
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
                cell.selectionStyle = .none
                return cell
            }else if self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Audio"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AudiomyCell", for: indexPath) as! AudiomyCell
                cell.play_btn.tag = indexPath.row
                cell.play_btn.addTarget(self, action: #selector(play_VideoLink(_ :)), for: .touchUpInside)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocmentmyCell", for: indexPath) as! DocmentmyCell
                cell.selectionStyle = .none
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
                cell.selectionStyle = .none
                let url = URL.init(string:self.viewModel?.userPreviousChat?.chatlist.reversed()[indexPath.row].message ?? "")
                cell.user_Img.sd_setImage(with:url, placeholderImage:UIImage(named: "dummy_user"))
                cell.play_btn.addTarget(self, action: #selector(play_VideoLink(_ :)), for: .touchUpInside)
                cell.play_btn.tag = indexPath.row
                return cell
            }else if self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Text"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageCell", for: indexPath) as! OtherMessageCell
                cell.msgLbl.text = self.viewModel?.userPreviousChat?.chatlist.reversed()[indexPath.row].message ?? ""
                
                cell.selectionStyle = .none
                return cell
            }else if self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].chatType == "Audio"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Audioanotheruser", for: indexPath) as! Audioanotheruser
                cell.play_btn.tag = indexPath.row
                cell.play_btn.addTarget(self, action: #selector(play_VideoLink(_ :)), for: .touchUpInside)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Docmentanotheruser", for: indexPath) as! Docmentanotheruser
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    @objc func play_VideoLink(_ sender :UIButton){
        self.playVideo(videoLink: self.viewModel.userPreviousChat?.chatlist.reversed()[sender.tag].message ?? "")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let chat_Info = self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row]{
            if chat_Info.chatType == "Image"{
                self.openActionSheet(imageUrl:self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].message ?? "", oneTitle: "Zoom Image", secondTitle: "Download Image", type: chat_Info.chatType ?? "")
            }else if  chat_Info.chatType == "File"{
                self.openActionSheet(imageUrl:self.viewModel.userPreviousChat?.chatlist.reversed()[indexPath.row].message ?? "", oneTitle: "Preview PDF", secondTitle: "Download PDF", type: chat_Info.chatType ?? "")
            }else{
                print("Some thing")
            }
        }
    }
    
    func playVideo(videoLink:String){
        guard let videoURL = URL(string: videoLink) else {return}
        let player = AVPlayer(url: videoURL)
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
    @IBOutlet weak var documentName:UILabel!
}

class Docmentanotheruser:UITableViewCell{
    @IBOutlet weak var user_Img:UIImageView!
    @IBOutlet weak var play_btn:UIButton!
}

class AudiomyCell:UITableViewCell{
    @IBOutlet weak var play_btn:UIButton!
}

class Audioanotheruser:UITableViewCell{
    @IBOutlet weak var play_btn:UIButton!
}
extension MessageVC:UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.viewModel.uploadFilesToServer(files:self.pickedImage,videoUrl:self.videoURl,FileURL:url, audioURL: self.audioURL)
    }
    
    func openActionSheet(imageUrl:String,oneTitle:String,secondTitle:String,type:String){
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:oneTitle, style: .default , handler:{ (UIAlertAction)in
            if type == "Image"{
                self.openZoomable_Img(imageUrl: imageUrl)
            }else{
                guard let url = URL(string: imageUrl) else {return}
                let controller = SFSafariViewController(url: url)
                self.present(controller, animated: true, completion: nil)
            }
            
        }))
        alert.addAction(UIAlertAction(title:secondTitle, style: .default , handler:{ (UIAlertAction)in
            if type == "Image"{
                self.downloadImge(imageUrl: imageUrl)
            }else{
                let url = URL(string: "http://www.filedownloader.com/mydemofile.pdf")
                FileDownloader.loadFileAsync(url: url!) { (path, error) in
                    print("PDF File downloaded to : \(path!)")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    fileprivate func openZoomable_Img(imageUrl:String){
        let vc = ZoomableImageSlider(images:[imageUrl], currentIndex:0, placeHolderImage: nil)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func downloadImge(imageUrl:String){
        DispatchQueue.global(qos: .background).async {
            do
            {
                let convert_Image = imageUrl
                let data = try Data.init(contentsOf: URL.init(string:convert_Image)!)
                DispatchQueue.main.async {
                    UIImageWriteToSavedPhotosAlbum(UIImage(data: data)!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
            }
            catch {
                
            }
        }
    }
}


extension Data{
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

extension MessageVC:RecordViewDelegate{
    func onStart() {
        mpRecorder.startAudioRecording()
    }
    
    func onCancel() {
        print("Cancel")
    }
    
    func onFinished(duration: CGFloat) {
        mpRecorder.stopAudioRecording()
    }
    
    
}

// MARK: - MPAudioRecorderDelegate
extension MessageVC: MPAudioRecorderDelegate
{
    func audioRecorderFailed(errorMessage: String)
    {
        print(errorMessage)
        
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        self.viewModel.uploadFilesToServer(files:self.pickedImage,videoUrl:self.videoURl,FileURL:self.fileURL, audioURL:recorder.url)
        
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?)
    {
        print("\(recorder) \n /n \(String(describing: error?.localizedDescription))")
    }
    
    func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder)
    {
        print("\(recorder)")
    }
    
    func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int)
    {
        print("\(recorder) \n /n \(flags)")
    }
    
    func audioSessionPermission(granted: Bool)
    {
        print(granted)
    }
}
