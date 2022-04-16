//
//  CreateProfileVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit

class CreateProfileVC: CustomiseViewController {
    @IBOutlet weak var support_Btn:UIButton!{
        didSet{
            self.support_Btn.underline()
        }
    }
    var viewModel:RegistrationViewModel!
    {
        didSet{
            self.viewModel?.username.bindAndFire{[unowned self] in self.txt_Email.text = $0}
        }
    }
    @IBOutlet weak var txt_Email:BindingAnimatable!{
        didSet{
            txt_Email.bind{[unowned self] in self.viewModel.username.value = $0 }
        }
    }
    @IBOutlet weak var txt_fullName:BindingAnimatable!{
        didSet{
            txt_fullName.bind{[unowned self] in self.viewModel.full_name.value = $0 }
        }
    }
    @IBOutlet weak var txt_Lastname:BindingAnimatable!{
        didSet{
            txt_Lastname.bind{[unowned self] in self.viewModel.last_name.value = $0 }
        }
    }
    @IBOutlet weak var txt_Country :BindingAnimatable!
    @IBOutlet weak var txt_DOB     :BindingAnimatable!
    @IBOutlet weak var txt_Gender  :BindingAnimatable!
    @IBOutlet weak var she_Btn:UIButton!
    @IBOutlet weak var he_Btn:UIButton!
    @IBOutlet weak var they_Btn:UIButton!
    
    @IBOutlet weak var userImg:UIImageView!
    var fontCamera    = false
    var images        = [String:Any]()
    var pickedImage   : UIImage?
    var gradePicker: UIPickerView!
    var userdetails : LoginResponseModel?
    
    let gradePickerValues = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapgesture(imageView: self.userImg)
        gradePicker = UIPickerView()
        self.viewModel = RegistrationViewModel.init(type: .CreateProfile)
        self.setUpVM(model: self.viewModel)
        gradePicker.dataSource = self
        gradePicker.delegate = self
        self.viewModel.username.value = self.userdetails?.patientInfo?.userName  ?? ""
        txt_Gender.inputView = gradePicker
        txt_Gender.text = gradePickerValues[0]
        self.txt_DOB.datePicker(target: self,doneAction: #selector(doneAction),cancelAction: #selector(cancelAction),datePickerMode: .date)
        
    }
    
    //MARK: - DatePicker Done button Action
    @objc func doneAction(textfield:UITextField){
        if let datePickerView = self.txt_DOB.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd,yyyy"
            self.viewModel.dob.value = dateFormatter.string(from:datePickerView.date)
            self.txt_DOB.text =  self.viewModel.dob.value
            txt_DOB.resignFirstResponder()
        }
    }
    
    
    @IBAction func getCountry_List(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryListTable") as? CountryListTable else {return}
        vc.countryID = {[weak self](id,name,country) in
            guard let self = self else {return}
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.txt_Country.text = name
                self.viewModel.country_Name.value = name
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func select_Birth(_ sender :UIButton){
        let btnTag = sender.tag
        switch btnTag{
        case 1:
            self.she_Btn.setImage(UIImage(named: "radio_on"), for: .normal)
            self.he_Btn.setImage(UIImage(named: "radio_off"), for: .normal)
            self.they_Btn.setImage(UIImage(named: "radio_off"), for: .normal)
        case 2:
            self.he_Btn.setImage(UIImage(named: "radio_on"), for: .normal)
            self.she_Btn.setImage(UIImage(named: "radio_off"), for: .normal)
            self.they_Btn.setImage(UIImage(named: "radio_off"), for: .normal)
        default:
            self.they_Btn.setImage(UIImage(named: "radio_on"), for: .normal)
            self.he_Btn.setImage(UIImage(named: "radio_off"), for: .normal)
            self.she_Btn.setImage(UIImage(named: "radio_off"), for: .normal)
        }
    }
    
    //MARK: - DatePicker Close  button Action
    @objc func cancelAction(textfield:UITextField){
        self.txt_DOB.resignFirstResponder()
    }
    
    fileprivate func addTapgesture(imageView:UIImageView){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func didTapImageView(_ sender: UITapGestureRecognizer) {
        ImagePickerController.init().pickImage(self, isCamraFront:fontCamera) { (img) in
            self.pickedImage = img
            self.images["identity_img"] = img
            self.userImg.image = img
        }
    }
    
    @IBAction func next_Btn(_ sender:UIButton){
        if self.images.count == 0{
            self.showErrorMessages(message: "Upload user profile photo")
        }else{
            if self.viewModel.isValid{
                let filledData = DetailsPass(FirstName: self.viewModel.full_name.value, ProfilePic: self.pickedImage, LastName: self.viewModel.last_name.value, Email: self.viewModel.username.value, Country: self.viewModel.country_Name.value, dob:self.viewModel.dob.value, gender:self.viewModel.gender.value, SK: self.userdetails?.patientInfo?.sk ?? "", Weight: "", Height: "")
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddWeightVC") as? AddWeightVC else {return}
                vc.data_Info = filledData
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.showErrorMessages(message: self.viewModel.brokenRules.first?.message ?? "")
            }
        }
        
    }
}


extension CreateProfileVC:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return gradePickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradePickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        txt_Gender.text = gradePickerValues[row]
        self.viewModel.gender.value = gradePickerValues[row]
        self.view.endEditing(true)
    }
}


struct DetailsPass{
    var FirstName:String?
    var ProfilePic:UIImage?
    var LastName:String?
    var Email:String?
    var Country:String?
    var dob:String?
    var gender:String?
    var SK:String?
    var Weight:String?
    var Height:String?
    
}
