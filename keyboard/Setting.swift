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

enum ScriptType {
    case latin
    case cyrillic
    case numMark
}

enum KeyFuction {
    case chr
    case space
    case newline
    case shift
    case delete
    case changeType
    case nextKeyboard
}

struct Const {
    static let latinList = ["ɣ", "e", "t", "u", "i", "o", "p", "ŋ", "ɛ", "ɔ", "a", "s", "d", "f", "g", "k", "ś", "ź", "š", "z", "x", "v", "b", "n", "m", "ž", " ", "\n"]
    static let latinExtraList = [1: "ğ", 8: "ñ", 9: "ê", 10: "ô"]
    static let latinFunctionList: [KeyFuction] = [.chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .space, .newline, .delete, .changeType, .nextKeyboard]
    
    static let cyrillicList = ["у", "к", "е", "н", "г", "ш", "з", "х", "ң", "ӏ", "ф", "в", "а", "п", "о", "д", "ж", "э", "ғ", "ә", "с", "м", "и", "т", "б", "с́", "з́", " ", "\n"]
    static let cyrillicFunctionList: [KeyFuction] = [.chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .space, .newline, .delete, .changeType, .nextKeyboard]
    
    static let numMarkList =
        [true: ["[", "]", "{", "}", "^", "+", "−", "×", "÷", "=", "_", "\\", "|", "<", ">", "#", "†", "@", "\"", "•", ".", ",", "?", "!", "«", "»", " ", "\n"],
         false: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "~", "–", "/", ":", ";", "(", ")", "*", "ⁱ", ".", ",", "?", "!", "«", "»", " ", "\n"]]
    static let numMarkExtraList =
        [true: [19: "'", 21: "…", 23: "⸮", 24: "‽", 25: "‹", 26: "›"],
         false: [13: "—", 21: "…", 23: "⸮", 24: "‽", 25: "‹", 26: "›"]]
    static let numMarkFunctionList: [KeyFuction] = [.chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .space, .newline, .shift, .delete, .changeType, .nextKeyboard]
    
    static let keyboardHeights: [CGFloat:CGFloat] =
        [568.0: 216.0, 667.0: 216.0, 736.0: 226.0, 812.0: 216.0, 896.0: 226.0,
         320.0: 160.0, 375.0: 187.5, 414.0: 207.0]
    
    static let portraitHeights: [CGFloat] = [568.0, 667.0, 736.0, 812.0, 896.0]
    static let landscapeHeights: [CGFloat] = [320.0, 375.0, 414.0]
    /*
     portrait:
     568.0: 5s, SE
     667.0: 6, 6s, 7, 8
     736.0: 6 plus, 6s plus, 7 plus, 8 plus
     812.0: X, XS
     896.0: XR, XS MAX
     lanscape:
     320.0: 5s, SE
     375.0: 6, 6s, 7, 8, X, XS
     414.0: 6 plus, 6s plus, 7 plus, 8 plus, XR, XS MAX
     */
    
    static let shiftInterval = 0.35
    
    static let lightChrKeysColour = UIColor.white
    static let lightOtherKeysColour = UIColor(red: 168/255, green: 173/255, blue: 184/255, alpha: 1)
    static let darkChrKeysColour = UIColor(red: 95/255, green: 95/255, blue: 95/255, alpha: 1)
    static let darkOtherKeysColour = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
    static let darkTappedShiftColour = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
}
