//
//  AddWeightVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit
import NMMultiUnitRuler
import IBAnimatable

class AddWeightVC: CustomiseViewController {
    @IBOutlet weak var ruler: NMMultiUnitRuler?
    var rangeStart = Measurement(value: 30.0, unit: UnitMass.kilograms)
    var rangeLength = Measurement(value: Double(90), unit: UnitMass.kilograms)
    
    var colorOverridesEnabled = false
    var moreMarkers = false
    var direction: NMLayerDirection = .horizontal
    @IBOutlet weak var kg_Btn:AnimatableButton!{
        didSet{
            self.kg_Btn.roundCorners(corners: [.topLeft, .topRight], flag: true)
        }
    }
    @IBOutlet weak var support_Btn:UIButton!{
        didSet{
            self.support_Btn.underline()
        }
    }
    @IBOutlet weak var previous_Btn:UIButton!
    @IBOutlet weak var next_Btn:UIButton!
    var screenApper = screenCome.Signup
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var headerHeight:NSLayoutConstraint!
    @IBOutlet weak var lbl_Btn:AnimatableButton!{
        didSet{
            self.lbl_Btn.roundCorners(corners: [.topLeft, .topRight], flag: false)
        }
    }
    
    var segments = Array<NMSegmentUnit>()
    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.headerView.isHidden = true
            self.headerHeight.constant = 0
        case .Edit:
            self.previous_Btn.isHidden = true
            self.headerView.isHidden = false
            self.headerHeight.constant = 74
            self.support_Btn.isHidden = true
            self.next_Btn.setTitle("Submit", for: .normal)
            
        }
    }
    
    
    @IBAction func continue_Btn(_ sender :UIButton)
    {
        switch screenApper {
        case .Signup:
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddHeightVC") as? AddHeightVC else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        case .Edit:
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}

extension AddWeightVC:NMMultiUnitRulerDataSource, NMMultiUnitRulerDelegate{
    
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
