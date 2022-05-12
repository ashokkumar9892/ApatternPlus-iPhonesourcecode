//
//  SocketBaseClassVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 02/05/22.
//

import UIKit
import SignalRClient

protocol ClassBVCDelegate: AnyObject {
    func changeBackgroundColor(_ color: UIColor?)
}

class SocketBaseClassVC: NSObject,ViewModel{
    var brokenRules       : [BrokenRule]    = [BrokenRule]()
    var username          : Dynamic<String> = Dynamic("")
    var SenderSK          : Dynamic<String> = Dynamic("")
    var ReceiverSK        : Dynamic<String> = Dynamic("")
    var userMessage       : Dynamic<String> = Dynamic("")
    var messageType       : Dynamic<String> = Dynamic("Text")
    
    private var emailCode : String          = ""
    var isValid           : Bool {
        get {
            self.brokenRules = [BrokenRule]()
            return self.brokenRules.count == 0 ? true : false
        }
    }
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didreceiveMessage: ((_ res:normalMessage) -> ())?
    var socketConnectCloser: (() -> ())?
    
    weak var delegate: ClassBVCDelegate?
    //API related Variable
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    //Firebase Auth User ID
    var userID : String? {
        didSet {
            guard let _ = userID else { return }
            self.didFinishFetch?()
        }
    }
    var chatUserInfo:GetChatList?
    var userPreviousChat:PreviousUserChat?
    var filesUpdated :UPloadFilesModel?
    
    static let sharedInstance = SocketBaseClassVC()
    private let serverUrl = "https://patternclinicapis.harishparas.com/ChatHub"
    private let dispatchQueue = DispatchQueue(label: "hubsamplephone.queue.dispatcheueuq")
    
    private var chatHubConnection: HubConnection?
    private var chatHubConnectionDelegate: HubConnectionDelegate?
    
    
    func makeSocketConnection(){
        self.chatHubConnectionDelegate = self
        self.chatHubConnection = HubConnectionBuilder(url: URL(string: self.serverUrl)!)
            .withLogging(minLogLevel: .debug)
            .withAutoReconnect()
            .withHubConnectionDelegate(delegate: self.chatHubConnectionDelegate!)
            .build()
        self.chatHubConnection!.start()
        
        self.chatHubConnection?.on(method: "ReceiveMessage", callback: { (result) in
            if let messagereponse = try? result.getArgument(type: normalMessage.self) {
                let mesasge_1 = Chatlist(senderID: messagereponse.senderSK ?? "", receiverId:"", sentOn: messagereponse.senton ?? "", message: messagereponse.message ?? "", chatType:messagereponse.messageType ?? "", isAdmin: true, isNotification: true)
                self.userPreviousChat?.chatlist.insert(mesasge_1, at:0)
                self.didFinishFetch?()
            }
        })
        
    }
    
    
    func getUserChatDetails(){
        Indicator.shared.show("Please Wait...")
        let model = NetworkManager.sharedInstance
        model.getuserChatList { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let res):
                self.chatUserInfo = res
                Indicator.shared.hide()
                self.didFinishFetch?()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    Indicator.shared.hide()
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
        
        //        let getUserChat = getChatList(SK: "PATIENT_1650619112058", AuthToken:UserDefaults.userToken)
        //
        //        self.chatHubConnection?.invoke(method: "UserChatList", arguments: [getUserChat], invocationDidComplete: { error in
        //            print(error?.localizedDescription as Any)
        //        })
        //        self.chatHubConnection?.on(method: "ShowUserChatList", callback: { (result) in
        //            if let messagereponse = try? result.getArgument(type: [ChatListModel].self) {
        //                self.chatUserInfo = messagereponse
        //                self.didFinishFetch?()
        //            }
        //        })
    }
    
    func uploadFilesToServer(files:UIImage?,videoUrl:URL?,FileURL:URL?){
        Indicator.shared.show("Uploading...")
        let model = NetworkManager.sharedInstance
        model.uploadFilestoserver(files: files, videoUrl: videoUrl, FileURL: FileURL) {[weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let res):
                self.filesUpdated = res
                self.userMessage.value = res.imageurls?[0].files ?? ""
                self.messageType.value = res.imageurls?[0].filetype ?? ""
                self.sendMessageToUser()
                Indicator.shared.hide()
                self.didFinishFetch?()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    Indicator.shared.hide()
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
    
    
    func sendMessageToUser(){
        let codData = SocketRequestModel(SenderSK:UserDefaults.User?.patientInfo?.sk ?? "", ReceiverSK:ReceiverSK.value, Message: userMessage.value, MessageType:messageType.value, AuthToken:UserDefaults.userToken)
        self.chatHubConnection?.invoke(method: "SendMessages", arguments: [codData], invocationDidComplete: { error in
            print(error,"Home")
        })
    }
    
    func getprevious_Chat(){
        Indicator.shared.show("Please Wait...")
        let model = NetworkManager.sharedInstance
        model.getuserPreviousChat(SenderSK:SenderSK.value, ReceiverSK:ReceiverSK.value) { [weak self]  (result) in
            guard let self = self else {return}
            switch result{
            case .success(let res):
                self.userPreviousChat = res
                Indicator.shared.hide()
                self.didFinishFetch?()
            case .failure(let err):
                switch err {
                case .errorReport(let desc):
                    Indicator.shared.hide()
                    self.error = desc
                }
                print(err.localizedDescription)
            }
        }
    }
}

struct SocketRequestModel:Codable {
    var SenderSK : String?
    var ReceiverSK : String?
    var Message : String?
    var MessageType : String?
    var AuthToken : String?
}

extension SocketBaseClassVC: HubConnectionDelegate {
    
    func connectionDidOpen(hubConnection: HubConnection) {
        print("connectionDidOpen")
        self.socketConnectCloser?()
    }
    func connectionDidFailToOpen(error: Error) {
        print("connectionDidFailToOpen")
    }
    
    func connectionDidClose(error: Error?) {
        print("connectionDidClose")
    }
    
    func connectionWillReconnect(error: Error) {
        print("connectionWillReconnect")
    }
    func connectionDidReconnect() {
        print("Re Connect Socket")
    }
}


struct ChatReponse:Codable{
    //var type:Int?
    var target:String?
    // var invocationId:String?
    var arguments:[MessageArguments]?
}

struct MessageArguments:Codable{
    var senderSK:String?
    //    var image:String?
    var senton:String?
    var message:String?
    var messageType:String?
}


struct getChatList:Codable{
    var SK:String?
    var AuthToken:String?
}


struct ChatListModel:Codable{
    var chatId:Int?
    var count:Int?
    var lastMessage:String?
    var name:String?
    var recieverSK:String?
    var senderSK:String?
    var unseencount:Int?
}


struct normalMessage:Codable{
    var senderSK:String?
    var senton:String?
    var message:String?
    var messageType:String?
    var recieverSK:String?
    var chatType:String?
}
