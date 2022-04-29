//
//  DectorsListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 06/04/22.
//

import UIKit

class DectorsListVC: CustomiseViewController {
    var callback_Closer: ((_ doctorName:String,_ doctorImg:String,_ tag:Int,_ doctor_Id:String) -> Void)?
    var coatch_Closer: ((_ coatchName:String,_ coatchImg:String,_ tag:Int,_  coatch_Id:String) -> Void)?
    var viewModel:RegistrationViewModel!
    @IBOutlet weak var dectorsTable:UITableView!
    @IBOutlet weak var back_View:UIView!
    var indexTag :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RegistrationViewModel(type:.SignIn)
        self.setUpVM(model: self.viewModel)
        
        self.addTapgesture(view:self.back_View)
        self.viewModel.didFinishFetch = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.dectorsTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if indexTag == 0{
            self.viewModel.getDectors_Info()
        }else{
            self.viewModel.getCoatchList()
        }
    }
    
    fileprivate func addTapgesture(view:UIView){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DectorsListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getDoctorsList?.doctorInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Doctors_InfoList") as? Doctors_InfoList {
            cell.selectionStyle = .none
            if let dectorDetails = self.viewModel.getDoctorsList?.doctorInfo?[indexPath.row]{
                cell.dectorName.text = dectorDetails.userName ?? ""
                cell.designation.text = dectorDetails.designation ?? ""
                let url = URL.init(string: dectorDetails.profileImage ?? "")
                cell.dectorImg.sd_setImage(with: url , placeholderImage:UIImage(named: "dummy_user"))
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexTag == 0{
            if let dector_Details = self.viewModel.getDoctorsList?.doctorInfo?[indexPath.row]{
                self.callback_Closer?(dector_Details.userName ?? "", dector_Details.profileImage ?? "", indexTag ?? 0, dector_Details.sk ?? "")
            }
        }else{
            if let coatch_Details = self.viewModel.getDoctorsList?.doctorInfo?[indexPath.row]{
                self.coatch_Closer?(coatch_Details.userName ?? "", coatch_Details.profileImage ?? "",indexTag ?? 0, coatch_Details.sk ?? "")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

class Doctors_InfoList:UITableViewCell{
    @IBOutlet weak var dectorName:UILabel!
    @IBOutlet weak var designation:UILabel!
    @IBOutlet weak var dectorImg:UIImageView!
}
