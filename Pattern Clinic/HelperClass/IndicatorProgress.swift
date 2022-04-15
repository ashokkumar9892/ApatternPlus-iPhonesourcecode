//
//  IndicatorProgress.swift
//  oink
//
//  Created by HarishParas on 20/06/20.
//  Copyright © 2020 HarishParas. All rights reserved.
//

import UIKit

final class Indicator {
    static let shared = Indicator()
    
    var blurImg   = UIImageView()
    var label     = UILabel()
    var indicator = UIActivityIndicatorView()
    
    private init() {
        blurImg.frame           = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.white
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha           = 1.0
        indicator.style         = .whiteLarge
        indicator.center        = blurImg.center
        indicator.color         = UIColor(named: "button_Colour")
        indicator.startAnimating()
        let y = indicator.frame.origin.y + indicator.frame.size.height + 20
        label = UILabel(frame: CGRect(x: 0, y: y, width: blurImg.frame.size.width, height: 25))
        label.textColor     =  UIColor(named: "Contact_blue")
        label.font = UIFont(name: "Outfit-Regular", size: 18.0)
        label.textAlignment = .center
    }
    
    func show(_ withText:String){
        DispatchQueue.main.async( execute: { [weak self] in
            guard let self = self else {return}
            self.label.text = withText
            UIApplication.shared.keyWindow?.addSubview(self.blurImg)
            UIApplication.shared.keyWindow?.addSubview(self.indicator)
            UIApplication.shared.keyWindow?.addSubview(self.label)
        })
    }
    
    func hide(){
        DispatchQueue.main.async( execute: {[weak self] in
            guard let self = self else {return}
            self.blurImg.removeFromSuperview()
            self.indicator.removeFromSuperview()
            self.label.removeFromSuperview()
        })
    }
}
