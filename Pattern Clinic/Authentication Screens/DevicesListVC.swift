//
//  DevicesListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//
import UIKit
import IBAnimatable
import VeepooBleSDK

class DevicesListVC: CustomiseViewController {
    @IBOutlet weak var tableHeight:NSLayoutConstraint!
    var device_List = [Device_Info]()
    @IBOutlet weak var device_table:UITableView!
    @IBOutlet weak var WatchesList:UITableView!
    //  let veepooBleManager: VPBleCentralManage = VPBleCentralManage.sharedBleManager()
    @IBOutlet weak var submit_btn:UIButton!{
        didSet{
            self.submit_btn.backgroundColor = UIColor(named:"blue_Back")
            self.submit_btn.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var support_Btn:UIButton!{
        didSet{
            self.support_Btn.underline()
        }
    }
    var selectedIndex = -1
    let veepooBleManager = VPBleCentralManage.sharedBleManager()
    var deviceArray: Array<VPPeripheralModel> = [VPPeripheralModel]()
    var screenApper = screenCome.Signup
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var hideView:UIView!
    @IBOutlet weak var instractionLbl:UILabel!
    @IBOutlet weak var watchtableHeight:NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableHeight.constant = 1*118
        VPBleCentralManage.sharedBleManager().isLogEnable = true
        VPBleCentralManage.sharedBleManager().peripheralManage = VPPeripheralManage.shareVPPeripheralManager()
        unowned let weakSelf = self
        //MARK: - Monitor the Bluetooth status change of the mobile phone system
        
        veepooBleManager?.vpBleCentralManageChangeBlock = {(centralManagerState: VPCentralManagerState) -> Void
            in
            switch centralManagerState {
            case .poweredOff: //系统蓝牙关闭
                print("Detected that the system bluetooth is off")
            case .poweredOn://系统蓝牙打开
                print("Detected that the system bluetooth is turned on")
                
            case .unknown://未知
                print("System Bluetooth status not detected")
            default:
                print("Other cases")
            }
        }
        
        //MARK: - Monitor device connection status changes
        
        veepooBleManager?.vpBleConnectStateChangeBlock = {(deviceConnectState: VPDeviceConnectState) -> Void
            in
            switch deviceConnectState {
            case .connectStateDisConnect: //断开连接
                weakSelf.deviceDidDisConnect()
            case .connectStateConnect://连接成功
                break
            case .connectStateVerifyPasswordSuccess://验证密F码成功
                break
                weakSelf.deviceVerifyPasswordSuccessful()
            case .connectStateVerifyPasswordFailure://验证密码失败
                break
            case .discoverNewUpdateFirm://发现新固件
                break
            }
        }
        
        VPPeripheralManage.shareVPPeripheralManager()?.receiveDeviceSOSCommand = {() -> Void in
            print("sos")
        }
        
        
        Static_InfoVC.sharedInstance.allDevice_Info { [weak self] in
            guard let self = self else {return}
            Dispatch.main{
                
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.device_List = Static_InfoVC.sharedInstance.device_List
                self.device_table.reloadData()
            }
        }
        
        
        
        switch screenApper {
        case .Signup:
            self.headerView.isHidden     = true
            self.instractionLbl.isHidden = false
            self.hideView.isHidden       = false
        case .Edit:
            self.headerView.isHidden     = false
            self.instractionLbl.isHidden = true
            self.support_Btn.isHidden    = true
            self.submit_btn.isHidden     = true
            self.hideView.isHidden       = true
            self.selectedIndex = 0
        }
    }
    
    func deviceDidDisConnect() {//设备已经断开连接
        // DestroyStepTimer()
        //  vpDisconnectDeviceButton.isEnabled = false
        if VPBleCentralManage.sharedBleManager().vpBleDFUConnectStateChangeBlock == nil {//如果没有固件升级断开连接返回到主界面
            print("Error in Watch Connection")
            
        }
    }
    
    /// 设备验证密码成功后的操作
    func deviceVerifyPasswordSuccessful() {//设备验证密码成功
        
        if VPBleCentralManage.sharedBleManager().vpBleDFUConnectStateChangeBlock != nil {//正在固件升级，自己也可以加判断条件
            return
        }
        //验证密码之后如果不是在DFU模式，第一步一定要先同步一下信息，最主要的是身高，同时App端修改个人信息后也一定要同步给设备，设置成功后在做其他事情，也可以向我这没写，因为一定会设置成功
        VPPeripheralManage.shareVPPeripheralManager().veepooSDKSynchronousPersonalInformation(withStature: 175, weight: 60, birth: 1995, sex: 0, targetStep: 10000) { (settingResult) in
            
        }
        
        veepooBleManager?.peripheralManage.veepooSDKReadDeviceBatteryPower { (batteryLevel) in
            
        }
        
        if veepooBleManager?.isDFULangMode == true {//如果处于DFULang模式则不再读取数据
            return
        }
        
        //验证密码成功后开始读取手环的数据（睡眠、计步、心率、血压等基本数据）
        VPBleCentralManage.sharedBleManager().peripheralManage.veepooSdkStartReadDeviceAllData {[weak self] (readDeviceBaseDataState, totalDay, currentReadDayNumber, readCurrentDayProgress) in
            switch readDeviceBaseDataState {
            case .start: //开始读取数据
                print("Start")
            case .reading://正在读取数据
                print("Reading")
            case .complete://读取数据完成
                print("Complet")
            default:
                break
            }
        }
        
        VPBleCentralManage.sharedBleManager().peripheralManage.veepooSDK_readSleepData(withDayNumber: 1) { (sleepArray) in
            guard  let sleepArray = sleepArray  else {
                return
            }
            print(sleepArray)
        }
        
        VPBleCentralManage.sharedBleManager().peripheralManage.veepooSDK_readBasicData(withDayNumber: 1, maxPackage: 1) { (heartArray, totalPackage, currentPackage) in
            guard  let heartArray = heartArray  else {
                return
            }
            print(heartArray)
        }
        
        VPBleCentralManage.sharedBleManager().peripheralManage.veepooSDK_readDeviceRunningData(withBlockNumber: 0) { (deviceRunningDict, totalPackage, currentPackage) in
            if currentPackage >= totalPackage {
                print(deviceRunningDict ?? "没有运动数据")
            }else {
                print("totalPackage:\(totalPackage) currentPackage:\(currentPackage)")
            }
        }
    }
    
    /// - Parameter peripheralModel: 设备的模型
    func addPeripheralToDeviceArray(peripheralModel: VPPeripheralModel) {
        Indicator.shared.show("Searching for devices...")
        var isExist = false
        for i in (0..<deviceArray.count) {
            let p = deviceArray[i]
            if p.deviceAddress == peripheralModel.deviceAddress {
                isExist = true
                break
            }
        }
        if isExist == false {
            deviceArray.append(peripheralModel)
            //按照信号进行排序
            deviceArray = deviceArray.sorted(by: { (p1, p2) -> Bool in
                return p1.rssi.intValue > p2.rssi.intValue
            })
            
            self.WatchesList.reloadData { [weak self] in
                guard let self = self else {return}
                Dispatch.main{
                    self.watchtableHeight.constant = self.WatchesList.contentSize.height
                }
                
            }
        }
        
        Indicator.shared.hide()
    }
    
    @IBAction func submit_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "PatternPlus_TeamVC") as? PatternPlus_TeamVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension DevicesListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == WatchesList{
            return self.deviceArray.count
        }else{
            return self.device_List.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == WatchesList{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WatchesList_Info", for: indexPath) as? WatchesList_Info else {
                return WatchesList_Info()}
            cell.selectionStyle = .none
            let device_List = deviceArray[indexPath.row]
            if selectedIndex == indexPath.row{
                cell.back_View.borderColor = UIColor(named:"button_Colour")
                cell.back_View.borderWidth = 1.0
            }else{
                cell.back_View.borderColor = .white
                cell.back_View.borderWidth = 1.0
            }
            cell.device_name.text = device_List.deviceAddress
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectDevice", for: indexPath) as? ConnectDevice else {
                return ConnectDevice()}
            cell.selectionStyle = .none
            if self.device_List[indexPath.row].flag == false || indexPath.row == selectedIndex{
                cell.backView.borderColor = UIColor(hexString: "#0000EE")
                self.device_List[indexPath.row].flag = true
                cell.backView.borderWidth = 1
            }else{
                cell.backView.borderColor = UIColor(hexString: "#ECECEC")
                cell.backView.borderWidth = 1
            }
            cell.device_Img.image = self.device_List[indexPath.row].image
            cell.device_name.text = self.device_List[indexPath.row].device_name ?? ""
            return cell
        }
    }
    
    /// - Parameter connectState: 蓝牙过程中的状态
    func handleConnectEvent(connectState: DeviceConnectState) {
        switch connectState {
        case .BlePoweredOff://蓝牙没有打开
            print("mobile phone bluetooth not turned on")
        case .BleConnecting://蓝牙连接中
            print("Bluetooth Connecting")
        case .BleConnectSuccess://蓝牙连接成功
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WatchConnectscucessPopVC") as? WatchConnectscucessPopVC else {return}
            vc.callBack_info = { [weak self] in
                guard let self = self else {return}
                Dispatch.main{
                    self.submit_btn.backgroundColor = UIColor(named:"button_Colour")
                    self.submit_btn.isUserInteractionEnabled = true
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case .BleConnectFailed://蓝牙连接失败
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WatchConnectscucessPopVC") as? WatchConnectscucessPopVC else {return}
            vc.callBack_info = { [weak self] in
                guard let self = self else {return}
                Dispatch.main{
                    self.submit_btn.backgroundColor = UIColor(named:"button_Colour")
                    self.submit_btn.isUserInteractionEnabled = true
                }
            }
            vc.connectionFlag = false
            self.navigationController?.pushViewController(vc, animated: true)
        case .BleVerifyPasswordSuccess://验证密码成功,返回上一级
            print("Password verification succeeded")
        case .BleVerifyPasswordFailure://验证密码失败
            print("Failed to verify password")
        @unknown default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == WatchesList{
            let p = deviceArray[indexPath.row]
            self.selectedIndex = indexPath.row
            self.WatchesList.reloadData()
            VPBleCentralManage.sharedBleManager().veepooSDKConnectDevice(p) { (connectState) in
                self.handleConnectEvent(connectState: connectState)
            }
        }else{
            switch screenApper {
            case .Signup:
                self.device_List[indexPath.row].flag = false
                self.device_table.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    guard let vc = StoryBoardSelection.sharedInstance.mainStoryBoard.instantiateViewController(withIdentifier: "BuyWatchVC") as? BuyWatchVC  else{return}
                    vc.callback = {
                        VPBleCentralManage.sharedBleManager().veepooSDKStartScanDeviceAndReceiveScanningDevice { [weak self](peripheralModel) in
                            guard let self = self else {return}
                            self.addPeripheralToDeviceArray(peripheralModel: peripheralModel!)
                        }
                    }
                    vc.modalPresentationStyle = .custom
                    self.present(vc, animated: true, completion:nil)
                    
                })
            case .Edit:
                break
            }
        }
    }
    
    
}

class ConnectDevice:UITableViewCell{
    @IBOutlet weak var backView:AnimatableView!
    @IBOutlet weak var device_Img:UIImageView!
    @IBOutlet weak var device_name:UILabel!
    
    
}


struct Device_Info{
    var device_name:String?
    var image:UIImage?
    var flag : Bool?
}


class WatchesList_Info:UITableViewCell{
    @IBOutlet weak var device_name:UILabel!
    @IBOutlet weak var back_View:AnimatableView!
}

//MARK: 销毁控制器前执行
//deinit {
//    VPBleCentralManage.sharedBleManager().veepooSDKStopScanDevice()
//}
