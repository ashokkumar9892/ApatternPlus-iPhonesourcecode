//
//  SocketBaseClassVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 02/05/22.
//

import UIKit
import SignalRClient

class SocketBaseClassVC: NSObject,ViewModel{
    var brokenRules       : [BrokenRule]    = [BrokenRule]()
    var username          : Dynamic<String> = Dynamic("")
    
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
    var socketConnectCloser: (() -> ())?
   
    
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
        
        
    }
    
    fileprivate func connectionDidOpen() {
        
        self.chatHubConnection?.on(method: "ReceiveMessage", callback: { (result) in
            if let messagereponse = try? result.getArgument(type: ChatReponse.self) {
                
            }
        })
        
      
       
        
    }
    
    
     func getUserChatDetails(){
        let getUserChat = getChatList(SK: "PATIENT_1645611610498", AuthToken: "eyJraWQiOiI3UGloR0p3MFlcL1dxdDRuSnMxQ0x0R2syOUZGYTZiSEhZVXpwNUY3N3Zlaz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZjIxNDFkMi0wMGU0LTQ4ZDItODZlZi1hZGEwOGE3YmNlOWMiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC51cy13ZXN0LTIuYW1hem9uYXdzLmNvbVwvdXMtd2VzdC0yXzVBMUI4dExjOSIsImNvZ25pdG86dXNlcm5hbWUiOiJhcHBzZGV2ZWxvcGVyMjJAZ21haWwuY29tIiwib3JpZ2luX2p0aSI6ImQ3Y2M3OTgwLWU0OWMtNDBhMC04OWI2LTEzMmY1MDM1YTNiZSIsImF1ZCI6IjJncTBkN2k3YTZydWwwcTBhaTdsN2RzaWRzIiwiZXZlbnRfaWQiOiI3OWYyNDliNC1hMDYzLTRlOWUtYTE4Ni02NzBjZmZiOTJkZTMiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTY1MTU2MTIwNCwiZXhwIjoxNjUxNTY0ODA0LCJpYXQiOjE2NTE1NjEyMDQsImp0aSI6ImU5YmRjYzhkLTI2OTgtNDFkMC1hZDY1LTY1OGE5MzllOTExOCIsImVtYWlsIjoiYXBwc2RldmVsb3BlcjIyQGdtYWlsLmNvbSJ9.bECI6fct819-kDp4OB71ZCKy5ZxhbaYjmxTAhr2hiusoGaGFmLdEjCQvQnIpSklnXtL_GONgqoB_haY4eyPmL4_1Ma_CzpcedseNPJKEUGhX1o4uTJyKuc9uv9L4qwfNskkuIvLKcWDZTi_9SPk9ZYDvOCKFNfWyv5Hg1tzmcFnlrPZyAdV8OSwohsbjt0KSFtigKQAFVRvJ60Keprn0I_X5GOGNGqQ4cucy_-SE0MwiyZn0w5HqiclXIb-cv4ZhBzz17_nQIcHXm8gmKAEXmriOwJrcq9JBCUuoBdgbdyjXscl3u7ecVs55uwPzGhPut-OCt8Eu23f9ktQnHQQPCA")
         
        self.chatHubConnection?.invoke(method: "UserChatList", arguments: [getUserChat], invocationDidComplete: { error in
            print(error?.localizedDescription)
        })
         
         self.chatHubConnection?.on(method: "ShowUserChatList", callback: { (result) in
             if let messagereponse = try? result.getArgument(type: ChatReponse.self) {
                 
             }
             
             
             
         })
         
    }
    
    
    fileprivate func sendMessageToUser(){
        let codData = SocketRequestModel(SenderSK: "PATIENT_1645611610498", ReceiverSK: "PATIENT_1650001697567", Message: "Paras", MessageType: "Text", AuthToken: "eyJraWQiOiI3UGloR0p3MFlcL1dxdDRuSnMxQ0x0R2syOUZGYTZiSEhZVXpwNUY3N3Zlaz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZjIxNDFkMi0wMGU0LTQ4ZDItODZlZi1hZGEwOGE3YmNlOWMiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC51cy13ZXN0LTIuYW1hem9uYXdzLmNvbVwvdXMtd2VzdC0yXzVBMUI4dExjOSIsImNvZ25pdG86dXNlcm5hbWUiOiJhcHBzZGV2ZWxvcGVyMjJAZ21haWwuY29tIiwib3JpZ2luX2p0aSI6IjE5ZmNjNWFiLTYwYzctNGFkOC04ZDE2LWVjOGEyYjg4NTg5NyIsImF1ZCI6IjJncTBkN2k3YTZydWwwcTBhaTdsN2RzaWRzIiwiZXZlbnRfaWQiOiIwYzc4MWE2OS1kZDg0LTQwYTQtOTIwMy02MWM5MjFlMTkxYWEiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTY1MTU1NjU0OSwiZXhwIjoxNjUxNTYwMTQ4LCJpYXQiOjE2NTE1NTY1NDksImp0aSI6IjIzYzQwY2MyLTMzNmMtNGQzMC1hMTc2LTBhMWU2MzM2ZTMyMyIsImVtYWlsIjoiYXBwc2RldmVsb3BlcjIyQGdtYWlsLmNvbSJ9.NXQ5Z_pi9_8yeZlRMLEpSG59WWTRWDkAAyFsv1ZPIlP_f6YXgmqj55yU1f6_3qeLMa8FmAsl6ISTtJ4owK46HVlKlO95J5RelyX6MUdJl-8rxmXRH8HXw9-aCuad7XfjQel4NH-84W4jduuRoF4-9WtSI7NncFU07gkmQs7ebOnS6ZZdBk3CoqSC2YAeWAI-CJRPCFmgY2NKhY1TODffSsv-ZtOfrhS6tGPoNSkkNEICdRm9BRQbF4iKEPCrNwsC0ZcB3-1AA9fOpgVFHcztHI-gNehN4Jx-wBtnq2AQ9gYCmbHXYaq4exAzVzuDVqaRAFTl5W22lAoTp7Fye5Qkmw")
        self.chatHubConnection?.invoke(method: "SendMessages", arguments: [codData]) { error in
            self.connectionDidOpen()
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
        getUserChatDetails()
      // self.socketConnectCloser?()
       // self.sendMessageToUser()
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
    var type:String?
    var target:String?
    var arguments:[MessageArguments]?
}

struct MessageArguments:Codable{
    var senderSK:String?
    var image:String?
    var senton:String?
    var message:String?
    var messageType:String?
}


struct getChatList:Codable{
    var SK:String?
    var AuthToken:String?
}
