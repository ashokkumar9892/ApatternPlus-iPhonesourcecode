//
//  StoryBoardSelection.swift
//  Pattern Clinic
//
//  Created by mac1 on 31/03/22.
//

import UIKit

class StoryBoardSelection: NSObject {
static let sharedInstance = StoryBoardSelection()
    var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    let settingsStoryBoard = UIStoryboard(name: "Settings", bundle: nil)
    let sideMenuStoryBoard = UIStoryboard(name: "SideMenu", bundle: nil)
    let healthStoryBoard = UIStoryboard(name: "HealthTips", bundle: nil)
    let coachStoryboard = UIStoryboard(name: "CoachAppointments", bundle: nil)
}
