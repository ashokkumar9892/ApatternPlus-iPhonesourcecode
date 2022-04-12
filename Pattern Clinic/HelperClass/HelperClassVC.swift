//
//  HelperClassVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit
import IBAnimatable

class HelperClassVC: NSObject {
    
}

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}




extension UIButton {
    func roundCorners(corners: UIRectCorner, radius: Int = 20,flag:Bool?) {
        var maskpath = UIBezierPath()
        maskpath = flag ?? true ? (UIBezierPath(roundedRect: bounds,
                                                byRoundingCorners: [.topLeft , .bottomLeft],
                                                cornerRadii: CGSize(width: radius, height: radius))) : (UIBezierPath(roundedRect: bounds,
                                                                                                                     byRoundingCorners: [.topRight , .bottomRight],
                                                                                                                     cornerRadii: CGSize(width: radius, height: radius)))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskpath.cgPath
        layer.mask = maskLayer1
    }
}




@IBDesignable
class CustomRightAndLeftImageButton:AnimatableButton {
    @IBInspectable var leftImage     : UIImage = UIImage()
    @IBInspectable var rightImage    : UIImage = UIImage()
    @IBInspectable var titleColor    : UIColor = UIColor.black
    @IBInspectable var titleStr      : String  = String()
    let title = UILabel()
    override func layoutSubviews() {
        super.layoutSubviews()
        title.text = titleStr
    }
    override func draw(_ rect: CGRect) {
        let leftImg = UIImageView(image: leftImage)
        leftImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftImg)
        leftImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        leftImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        title.text = titleStr
        title.font = UIFont.init(name:"Outfit-Light", size: 18.0)
        title.textColor = titleColor
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let rightImg = UIImageView(image: rightImage)
        rightImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rightImg)
        rightImg.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        rightImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

extension UITableView {
    
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    func reloadDataWithAutoSizingCellWorkAround()
    {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
    }
    func reloadArticleData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadDataWithAutoSizingCellWorkAround() })
        { _ in completion() }
    }
    func addShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.masksToBounds = false
    }
}



import UIKit
class TableViewDataSource<Cell :UITableViewCell,ViewModel> : NSObject, UITableViewDataSource {
    private var cellIdentifier :String!
    private var items :[ViewModel]!
    var configureCell :(Cell,ViewModel) -> ()
    init(cellIdentifier :String, items :[ViewModel], configureCell: @escaping (Cell,ViewModel) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! Cell
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        let item = self.items[indexPath.row]
        self.configureCell(cell,item)
        return cell
    }
}
class CollectionViewDataSource<Cell :UICollectionViewCell,ViewModel> : NSObject, UICollectionViewDataSource {
    private var cellIdentifier :String!
    private var items :[ViewModel]!
    var configureCell :(Cell,ViewModel) -> ()
    init(cellIdentifier :String, items :[ViewModel], configureCell: @escaping (Cell,ViewModel) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! Cell
        cell.tag = indexPath.row
        let item = self.items[indexPath.row]
        self.configureCell(cell,item)
        return cell
    }
}


