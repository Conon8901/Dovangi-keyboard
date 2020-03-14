//
//  Setting.swift
//  keyboard
//
//  Created by 黒岩修 on 2/24/2 R.
//  Copyright © 2 Reiwa 黒岩修. All rights reserved.
//

import UIKit

extension UIView {
    func setShadow() {
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.2)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 0
    }
    
    var subButtons: [UIButton] {
        get {
            var buttonArray = [UIButton]()
            
            for stack in self.subviews {
                for buttontobe in stack.subviews {
                    if let button = buttontobe as? UIButton {
                        buttonArray.append(button)
                    } else {
                        for buttontobe2 in buttontobe.subviews {
                            let button = buttontobe2 as! UIButton
                            buttonArray.append(button)
                        }
                    }
                }
            }
            
            return buttonArray
        }
    }
}

public func constraint(_ view1: AnyObject,
                       _ attr1: NSLayoutConstraint.Attribute,
                       relatedBy relation: NSLayoutConstraint.Relation = .equal,
                       to view2: AnyObject? = nil,
                       _ attr2: NSLayoutConstraint.Attribute = .notAnAttribute,
                       multiplier: CGFloat = 1.0,
                       constant: CGFloat = 0.0,
                       priority: UILayoutPriority = UILayoutPriority.required) -> NSLayoutConstraint {
    let const = NSLayoutConstraint(
        item:       view1,
        attribute:  attr1,
        relatedBy:  relation,
        toItem:     view2,
        attribute:  attr2,
        multiplier: multiplier,
        constant:   constant
    )
    const.priority = priority
    return const
}
