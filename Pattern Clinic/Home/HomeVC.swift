//
//  HomeVC.swift
//  Pattern Clinic
//
//  Created by mac1 on 05/04/22.
//

import UIKit

class HomeVC: CustomiseViewController {
    @IBOutlet weak var tableheight:NSLayoutConstraint!
    @IBOutlet weak var viewall_btn:UIButton!{
        didSet{
            self.viewall_btn.underline()
        }
    }
    @IBOutlet weak var score_View:UIView!
    @IBOutlet weak var progressTracker:UIView!
    @IBOutlet weak var graphView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableheight.constant = 260
        self.addTapgesture(view:self.score_View)
        self.addTapgesture(view:self.progressTracker)
        self.addTapgesture(view:self.graphView)
        //  self.changeStatusColor(colour: UIColor(hexString: "#0000EE"))
        
    }
    
    @IBAction func viewAll_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TodayActivityListVC") as? TodayActivityListVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func accountability_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrendsVC") as? TrendsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func optimal_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptimalFitnessVC") as? OptimalFitnessVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tracking_Btn(_ sender :UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NutritionTrackingVC") as? NutritionTrackingVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func addTapgesture(view:UIView){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if sender?.view?.tag == 10{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProgressTrackerVC") as? ProgressTrackerVC else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sender?.view?.tag == 11 {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "YourMetricsVC") as? YourMetricsVC else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AP__ScoreVC") as? AP__ScoreVC else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func forword_Btn(_ sender:UIButton){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "YourMetricsVC") as? YourMetricsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Activity_List") as? Activity_List {
            cell.selectionStyle = .none
            if indexPath.row == 0{
                cell.complete_Btn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
                cell.complete_Btn.setTitle("Completed", for: .normal)
                cell.complete_Btn.backgroundColor = UIColor(hexString: "#00BE59")
                
            }else{
                cell.complete_Btn.setTitleColor(UIColor(hexString: "#787878"), for: .normal)
                cell.complete_Btn.setTitle("Complete", for: .normal)
                cell.complete_Btn.backgroundColor = UIColor(hexString: "#EFEFEF")
            }
            cell.complete_Btn.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
            cell.complete_Btn.tag = indexPath.row
            return cell
        }
        
        return UITableViewCell()
    }
    @objc func addAction(_ sender :UIButton){
        if sender.tag != 0{
            guard let vc = StoryBoardSelection.sharedInstance.healthStoryBoard.instantiateViewController(withIdentifier: "CompletePopUpVC") as? CompletePopUpVC  else{return}
            vc.modalPresentationStyle = .custom
            
            self.present(vc, animated: true, completion:nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExerciseStatsVC") as? ExerciseStatsVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


class Activity_List:UITableViewCell{
    @IBOutlet weak var complete_Btn:UIButton!
}
