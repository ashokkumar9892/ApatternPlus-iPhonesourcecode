//
//  TutorialScreenVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 01/04/22.
//

import UIKit
import  SwiftyGif

class TutorialScreenVC: CustomiseViewController {
    var gifArray =  ["AP App screens 1","AP App screens 2","AP App screens 3","AP App screens 4","AP App screens 5","AP App screens 6","AP App screens 7","AP App screens 8","AP App screens 9"]
    @IBOutlet weak var gifCollection:UICollectionView!
    @IBOutlet weak var  pagelbl:UILabel!
    @IBOutlet weak var  countLbl:UILabel!
    @IBOutlet weak var bottomView:UIView!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(updateUI), with: nil, afterDelay: 0)
    }
    
    @objc func updateUI() {
        self.bottomView.applyGradient(colours: [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)], locations: [0.1, 1])
    }
    
    @IBAction func skip_Btn(_ sender :UIButton){
        if sender.tag == 0{
            defaults.set(true, forKey: "ONBOARDING")
            let visibleItems: NSArray = self.gifCollection.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.row == 9{
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                if nextItem.row < gifArray.count {
                    self.gifCollection.scrollToItem(at: nextItem, at: .left, animated: true)
                }
            }
        }else{
            defaults.set(true, forKey: "ONBOARDING")
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension TutorialScreenVC:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gifArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCell", for: indexPath) as? TutorialCell else {return TutorialCell()}
        let gif = try! UIImage(gifName:self.gifArray[indexPath.row])
        cell.gifImg.setGifImage(gif, loopCount: -1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = self.gifCollection.frame.size.width
        let index = Int(self.gifCollection.contentOffset.x / pageWidth) + 1
        self.pagelbl.text = "\(index)"
    }
}

class TutorialCell:UICollectionViewCell{
    @IBOutlet weak var gifImg:UIImageView!
    
}
