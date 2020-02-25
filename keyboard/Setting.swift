//
//  Setting.swift
//  keyboard
//
//  Created by 黒岩修 on 2/24/2 R.
//  Copyright © 2 Reiwa 黒岩修. All rights reserved.
//

import UIKit

extension UIView {
    func roundedCornerise() {
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.2)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 0
    }
    
    func fillSuperView() {
        self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: 0.0).isActive = true
        self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: 0.0).isActive = true
        self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: 0.0).isActive = true
        self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: 0.0).isActive = true
    }
}
