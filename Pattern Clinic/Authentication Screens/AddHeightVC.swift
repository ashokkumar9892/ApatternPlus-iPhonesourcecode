//
//  AddHeightVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit
import NMMultiUnitRuler

enum screenCome{
    case Signup
    case Edit
}

class AddHeightVC: CustomiseViewController {
    @IBOutlet weak var ruler: NMMultiUnitRuler?
    var rangeStart = Measurement(value: 1.0, unit: UnitMass.kilograms)
    var rangeLength = Measurement(value: Double(10), unit: UnitMass.kilograms)
    var colorOverridesEnabled = false
    var moreMarkers = false
    var direction: NMLayerDirection = .horizontal
    var segments = Array<NMSegmentUnit>()
    @IBOutlet weak var previous_Btn:UIButton!
    @IBOutlet weak var next_Btn:UIButton!
    
    @IBOutlet weak var support_Btn:UIButton!{
        didSet{
            self.support_Btn.underline()
        }
    }
    var screenApper = screenCome.Signup
    var data_Info :DetailsPass?
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var headerHeight:NSLayoutConstraint!
    @IBOutlet weak var heightLbl:UILabel!
    var viewModel :RegistrationViewModel!{
        didSet{
            self.viewModel.full_name.value = self.data_Info?.FirstName ?? ""
            self.viewModel.last_name.value = self.data_Info?.LastName ?? ""
            self.viewModel.username.value  = self.data_Info?.Email ?? ""
            self.viewModel.country_Name.value  = self.data_Info?.Country ?? ""
            self.viewModel.SK.value  = self.data_Info?.SK ?? ""
            self.viewModel.dob.value  = self.data_Info?.dob ?? ""
            self.viewModel.gender.value  = self.data_Info?.gender ?? ""
            self.viewModel.weight.value = self.data_Info?.Weight ?? ""
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RegistrationViewModel.init(type: .addHeight)
        self.setUpVM(model: self.viewModel)
        if data_Info?.ProfilePic == nil{
            self.viewModel.userProfile_Pic.value = self.data_Info?.base64String ?? ""
        }else{
            if  let stringImg = imageToBase64(self.data_Info?.ProfilePic ?? UIImage()){
                self.viewModel.userProfile_Pic.value = stringImg
            }
        }
       
        
       
        ruler?.direction = .horizontal
        ruler?.tintColor = UIColor(red: 0.15, green: 0.18, blue: 0.48, alpha: 1.0)
        //  controlHConstraint?.constant = 240.0
        segments = self.createSegments()
        ruler?.delegate = self
        ruler?.dataSource = self
        
        let initialValue = (self.rangeForUnit(UnitMass.kilograms).location + self.rangeForUnit(UnitMass.kilograms).length) / 2
        ruler?.measurement = NSMeasurement(
            doubleValue: Double(initialValue),
            unit: UnitMass.kilograms)
        self.view.layoutSubviews()
        switch screenApper {
        case .Signup:
            self.headerHeight.constant = 0
            self.headerView.isHidden = true
        case .Edit:
            self.previous_Btn.isHidden = true
            self.support_Btn.isHidden = true
            self.headerHeight.constant = 74
            self.headerView.isHidden = false
            self.next_Btn.setTitle("Submit", for: .normal)
            
        }
        
        self.viewModel.didFinishFetch = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DevicesListVC") as? DevicesListVC else {return}
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    @IBAction func next_Btn(_ sender:UIButton){
        switch screenApper {
        case .Signup:
            if self.viewModel.isValid{
                self.viewModel.createProfile()
               
            }else{
                self.showErrorMessages(message: self.viewModel.brokenRules.first?.message ?? "")
            }
           
        case .Edit:
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
extension AddHeightVC:NMMultiUnitRulerDataSource, NMMultiUnitRulerDelegate{
    
    func unitForSegmentAtIndex(index: Int) -> NMSegmentUnit {
        return segments[index]
    }
    
    var numberOfSegments: Int {
        get {
            return segments.count
        }
        set {
        }
    }
    
    func valueChanged(measurement: NSMeasurement) {
        self.heightLbl.text = "\(measurement.doubleValue)"
        self.viewModel.height.value = "\(measurement.doubleValue)"
        print("value changed to \(measurement.doubleValue)")
    }
    
    
    private func createSegments() -> Array<NMSegmentUnit> {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .providedUnit
        let kgSegment = NMSegmentUnit(name: "Kilograms", unit: UnitMass.kilograms, formatter: formatter)
        
        kgSegment.name = "Kilogram"
        kgSegment.unit = UnitMass.kilograms
        let kgMarkerTypeMax = NMRangeMarkerType(color: UIColor.white, size: CGSize(width: 1.0, height: 70.0), scale: 5.0)
        kgMarkerTypeMax.labelVisible = true
        kgSegment.markerTypes = [
            NMRangeMarkerType(color: UIColor(hexString: "#D5D5D5"), size: CGSize(width: 1.0, height: 35.0), scale: 0.5),
            NMRangeMarkerType(color: UIColor(hexString: "#D5D5D5"), size: CGSize(width: 1.0, height: 50.0), scale: 1.0)]
        
        let lbsSegment = NMSegmentUnit(name: "Pounds", unit: UnitMass.pounds, formatter: formatter)
        let lbsMarkerTypeMax = NMRangeMarkerType(color: UIColor.white, size: CGSize(width: 1.0, height: 50.0), scale: 10.0)
        
        lbsSegment.markerTypes = [
            NMRangeMarkerType(color: UIColor.white, size: CGSize(width: 1.0, height: 35.0), scale: 1.0)]
        
        if moreMarkers {
            kgSegment.markerTypes.append(kgMarkerTypeMax)
            lbsSegment.markerTypes.append(lbsMarkerTypeMax)
        }
        kgSegment.markerTypes.last?.labelVisible = true
        lbsSegment.markerTypes.last?.labelVisible = true
        return [kgSegment, lbsSegment]
    }
    
    
    func rangeForUnit(_ unit: Dimension) -> NMRange<Float> {
        let locationConverted = rangeStart.converted(to: unit as! UnitMass)
        let lengthConverted = rangeLength.converted(to: unit as! UnitMass)
        return NMRange<Float>(location: ceilf(Float(locationConverted.value)),
                              length: ceilf(Float(lengthConverted.value)))
    }
    
    func styleForUnit(_ unit: Dimension) -> NMSegmentUnitControlStyle {
        let style: NMSegmentUnitControlStyle = NMSegmentUnitControlStyle()
        style.scrollViewBackgroundColor = UIColor.white
        let range = self.rangeForUnit(unit)
        if unit == UnitMass.pounds {
            
            style.textFieldBackgroundColor = UIColor.clear
            // color override location:location+40% red , location+60%:location.100% green
        } else {
            style.textFieldBackgroundColor = UIColor.red
        }
        if (colorOverridesEnabled) {
            style.colorOverrides = [
                NMRange<Float>(location: range.location, length: 0.1 * (range.length)): UIColor.red,
                NMRange<Float>(location: range.location + 0.4 * (range.length), length: 0.2 * (range.length)): UIColor.green]
        }
        style.textFieldBackgroundColor = UIColor.clear
        style.textFieldTextColor = UIColor.clear
        return style
    }
    
}
