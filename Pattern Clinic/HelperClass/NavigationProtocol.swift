//
//  NavigationProtocol.swift
//  NBP-Baseball App
//
//  Created by MAC on 04/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import UIKit
import KYDrawerController
import SDWebImage



class CustomiseViewController : UIViewController {
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
    }
    func changeStatusColor(colour:UIColor?){
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = colour
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                statusBar.backgroundColor = colour
                
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    func logOut(){
        let storyBoard = StoryBoardSelection.sharedInstance.mainStoryBoard
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else{return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func openViewControllerBasedOnStoryBoard(_ strIdentifier:String, _ storyBoard:String) -> UIViewController {
        var viewController = UIViewController()
        
        let storyBoard:UIStoryboard? = UIStoryboard.init(name: storyBoard, bundle: Bundle.main)
        
        if #available(iOS 13.0, *) {
            
            if let destViewController : UIViewController = storyBoard?.instantiateViewController(identifier: strIdentifier){
                viewController = destViewController
                destViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(destViewController, animated: false)
            }
        }
        else{
            if let destViewController : UIViewController = storyBoard?.instantiateViewController(withIdentifier: strIdentifier) {
                viewController = destViewController
                destViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(destViewController, animated: false)
            }
        }
        return viewController
    }
    
    @IBAction func close_Sidemenu(_ sender :UIButton){
        if let vc = parent as? KYDrawerController {
            vc.setDrawerState(.closed, animated: true)
        }
    }
    
    @IBAction func action_SideMenu(_ sender:UIButton) {
        if let vc = parent as? KYDrawerController {
            vc.setDrawerState(.opened, animated: true)
        }
        if let vc = (parent as? KYDrawerController)?.drawerViewController as? MenuVC {
            vc.currentActivePage = sender.tag
            vc.selectedActionType = { [weak self](type) -> () in
                guard let self = self else {return}
                switch type {
                case .Home:
                    (self.parent as? KYDrawerController)?.mainViewController = self.openViewControllerBasedOnStoryBoard("HomeVC", "SideMenu")
                case .CoachingAppointments:
                    (self.parent as? KYDrawerController)?.mainViewController = self.openViewControllerBasedOnStoryBoard("CoachAppointmentsVC", "CoachAppointments")
                case .Messages:
                    (self.parent as? KYDrawerController)?.mainViewController = self.openViewControllerBasedOnStoryBoard("MessageListVC", "SideMenu")
                case .PersonalMetrics:
                    (self.parent as? KYDrawerController)?.mainViewController = self.openViewControllerBasedOnStoryBoard("PersonalMetricsVC", "SideMenu")
                case .HealthTips:
                    (self.parent as? KYDrawerController)?.mainViewController = self.openViewControllerBasedOnStoryBoard("HealthTipsListVC", "HealthTips")
                    
                case .MyProfile:
                    (self.parent as? KYDrawerController)?.mainViewController = self.openViewControllerBasedOnStoryBoard("ProfileSettingsVC", "SideMenu")
                case .Settings:
                    (self.parent as? KYDrawerController)?.mainViewController = self.openViewControllerBasedOnStoryBoard("SettingsVC", "Settings")
                }
            }
        }
    }
    
    @IBAction func contact_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactSupportVC") as? ContactSupportVC else {return}
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func navigationBarBackAction(_ sender:UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func disMiss_Btn(_ sender :UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
}


extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController?.childForStatusBarStyle ?? selectedViewController
    }
}

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController?.childForStatusBarStyle ?? topViewController
    }
}
extension CustomiseViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}



extension CustomiseViewController {
    func setUpVM(model:ViewModel){
        hideKeyboardWhenTappedAround()
        var viewModel = model
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                
            }
        }
        viewModel.showAlertClosure = {  [weak self] in
            if let error = viewModel.error {
                print(error)
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.view.makeToast(error, duration: 0.5, position: .bottom,title:"")
                }
            }
        }
    }
    func showErrorMessages(message:String) {
        DispatchQueue.main.async {
            self.view.makeToast(message, duration: 0.5, position: .bottom,title:"")
            
        }
    }
    func showSuccessMessages(message:String,title:String = "") {
        DispatchQueue.main.async {
            self.view.makeToast(message, duration: 0.5, position: .bottom,title:title)
        }
    }
}
