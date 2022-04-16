//
//  DectorsListVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 06/04/22.
//

import UIKit

class DectorsListVC: CustomiseViewController {
    var callback_Closer:(() -> ())?
    var viewModel:RegistrationViewModel!
    @IBOutlet weak var dectorsTable:UITableView!
    var indexTag :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RegistrationViewModel(type:.SignIn)
        self.setUpVM(model: self.viewModel)
        if indexTag == 0{
            self.viewModel.getDectors_Info()
        }else{
            self.viewModel.getCoatchList()
        }
        
        self.viewModel.didFinishFetch = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.dectorsTable.reloadData()
            }
        }
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
        self.callback_Closer?()
        self.dismiss(animated: true, completion: nil)
    }
}

class Doctors_InfoList:UITableViewCell{
    @IBOutlet weak var dectorName:UILabel!
    @IBOutlet weak var designation:UILabel!
    @IBOutlet weak var dectorImg:UIImageView!
}
