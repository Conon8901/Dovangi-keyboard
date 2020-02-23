//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by 黒岩修 on 1/14/2 R.
//  Copyright © 2 Reiwa 黒岩修. All rights reserved.
//

import UIKit
import AudioToolbox

class KeyboardViewController: UIInputViewController {
    
    // MARK:- Setting
    
    enum keyboardType {
        case latin
        case cyrillic
        case numMark
    }
    
    struct Const {
        static var isShift = false
        //        static var isShiftSucceeding = false
        static var isExtra = false
        
        static let latinList = [true: ["Ƣ", "Ɋ", "E", "Ɛ", "T", "Ł", "U", "İ", "O", "Ɔ", "P", "A", "S", "D", "Ɗ", "F", "G", "Ɠ", "Ŋ", "K", "L", "R", "Z", "Ȥ", "X", "V", "Ʋ", "B", "Ɓ", "N", "M"], false: ["ƣ", "ɋ", "e", "ɛ", "t", "ł", "u", "i", "o", "ɔ", "p", "a", "s", "d", "ɗ", "f", "g", "ɠ", "ŋ", "k", "l", "r", "z", "ȥ", "x", "v", "ʋ", "b", "ɓ", "n", "m"]]
        static let latinExtraList = [true: [1: "Q", 2: "Q̆", 4: "Ê", 8: "Y", 10: "Ô", 15: "D̆", 18: "Ğ", 19: "Ñ", 24: "Z̆", 27: "V̆", 29: "B̆"], false: [1: "q", 2: "q̆", 4: "ê", 10: "ô", 15: "d̆", 18: "ğ", 19: "ñ", 24: "z̆", 27: "v̆", 29: "b̆"]]
        static let cyrillicList = [true: ["У", "К", "Е", "Н", "Г", "З", "Х", "Ъ", "Ң", "Ғ", "Ф", "В", "А", "П", "О", "Л", "Д", "Э", "Ԓ", "С", "М", "И", "Т", "Б", "Ә", "◌̆"], false: ["у", "к", "е", "н", "г", "з", "х", "ъ", "ң", "ғ", "ф", "в", "а", "п", "о", "л", "д", "э", "ԓ", "с", "м", "и", "т", "б", "Ә", "◌̆"]]
        static let numMarkList = [true: ["[", "]", "#", "%", "^", "+", "−", "×", "÷", "=", "_", "<", ">", "†", "§", "ɸ", "β", "ɣ", "ɬ", "ɮ", ".", ",", "?", "!", "«", "»"], false: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "~", "–", "/", ":", ";", "(", ")", "*", "\"", ".", ",", "?", "!", "«", "»"]]
        static let numMarkExtraList = [true: [4: "‰", 11: "‾", 15: "¶", 21: "…", 23: "⸮", 24: "‽"], false: [11: "•", 13: "—", 20: "'", 21: "…", 23: "⸮", 24: "‽"]]
    }
    
    var latinKeyboard: UIView!
    var cyrillicKeyboard: UIView!
    var numMarkKeyboard: UIView!
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    // MARK:- Bases
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // キーボードの高さ指定
        let constraintH = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 226)
        constraintH.priority = UILayoutPriority(rawValue: 990)
        self.view.addConstraint(constraintH)
        
        // Latin
        latinKeyboard = UINib(nibName: "Latin", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        latinKeyboard.frame = view.frame
        latinKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in self.latinKeyboard.subviews {
            if stack is UIStackView {
                for keytobe in stack.subviews {
                    let key = keytobe as! UIButton
                    key.roundedCornerise()
                    
                    //                    if key.tag == 33 {
                    //                        let singleRecog = UITapGestureRecognizer(target: self, action: #selector(self.shiftPressed))
                    //                        singleRecog.cancelsTouchesInView = false
                    //                        singleRecog.numberOfTapsRequired = 1
                    //                        key.addGestureRecognizer(singleRecog)
                    //
                    //                        let doubleRecog = UITapGestureRecognizer(target: self, action: #selector(self.shiftPressed))
                    //                        doubleRecog.cancelsTouchesInView = false
                    //                        doubleRecog.numberOfTapsRequired = 2
                    //                        key.addGestureRecognizer(doubleRecog)
                    //
                    //                        singleRecog.require(toFail: doubleRecog)
                    //                    } else
                    
                    if key.tag == 35 { // deleteKey
                        key.addTarget(self, action: #selector(deleteChr), for: .touchDown)
                        key.addTarget(self, action: #selector(deleteKeyTouchedDown), for: .touchDown)
                    } else {
                        key.addTarget(self, action: #selector(latinKeyPressed), for: .touchUpInside)
                        
                        if key.tag >= 32 {
                            key.addTarget(self, action: #selector(otherKeyTouchedDown), for: .touchDown)
                        } else {
                            key.addTarget(self, action: #selector(keyTouchedDown), for: .touchDown)
                        }
                    }
                }
            }
        }
        
        // Cyrillic
        cyrillicKeyboard = UINib(nibName: "Cyrillic", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        cyrillicKeyboard.frame = view.frame
        cyrillicKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in self.cyrillicKeyboard.subviews {
            if stack is UIStackView {
                for keytobe in stack.subviews {
                    if let key = keytobe as? UIButton {
                        key.roundedCornerise()
                        
                        if key.tag == 30 { // deleteKey
                            key.addTarget(self, action: #selector(deleteChr), for: .touchDown)
                            key.addTarget(self, action: #selector(deleteKeyTouchedDown), for: .touchDown)
                        } else {
                            key.addTarget(self, action: #selector(cyrillicKeyPressed), for: .touchUpInside)
                            
                            if key.tag >= 27 {
                                key.addTarget(self, action: #selector(otherKeyTouchedDown), for: .touchDown)
                            } else {
                                key.addTarget(self, action: #selector(keyTouchedDown), for: .touchDown)
                            }
                        }
                    } else {
                        for keys in keytobe.subviews {
                            let key = keys as! UIButton
                            key.roundedCornerise()
                            
                            key.addTarget(self, action: #selector(cyrillicKeyPressed), for: .touchUpInside)
                            
                            key.addTarget(self, action: #selector(keyTouchedDown), for: .touchDown)
                        }
                    }
                }
            }
        }
        
        // Num + Mark
        numMarkKeyboard = UINib(nibName: "NumMark", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        numMarkKeyboard.frame = view.frame
        numMarkKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in self.numMarkKeyboard.subviews {
            if stack is UIStackView {
                for keytobe in stack.subviews {
                    if let key = keytobe as? UIButton {
                        key.roundedCornerise()
                        
                        if key.tag == 30 { // deleteKey
                            key.addTarget(self, action: #selector(deleteChr), for: .touchDown)
                            key.addTarget(self, action: #selector(deleteKeyTouchedDown), for: .touchDown)
                        } else {
                            key.addTarget(self, action: #selector(numMarkKeyPressed), for: .touchUpInside)
                            
                            if key.tag >= 27 {
                                key.addTarget(self, action: #selector(otherKeyTouchedDown), for: .touchDown)
                            } else {
                                key.addTarget(self, action: #selector(keyTouchedDown), for: .touchDown)
                            }
                        }
                    } else {
                        for keys in keytobe.subviews {
                            let key = keys as! UIButton
                            key.roundedCornerise()
                            
                            key.addTarget(self, action: #selector(numMarkKeyPressed), for: .touchUpInside)
                            
                            key.addTarget(self, action: #selector(keyTouchedDown), for: .touchDown)
                        }
                    }
                }
            }
        }
        
        // Set Keyboard
        view.addSubview(latinKeyboard)
        latinKeyboard.fillSuperView()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        // Substitution Setting
        let qRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupQExtra))
        qRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 1)!.addGestureRecognizer(qRecog)
        
        let ngqRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupNgqExtra))
        ngqRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 2)!.addGestureRecognizer(ngqRecog)
        
        let erRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupErExtra))
        erRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 4)!.addGestureRecognizer(erRecog)
        
        let iRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupIExtra))
        iRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 8)!.addGestureRecognizer(iRecog)
        
        let orRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupOrExtra))
        orRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 10)!.addGestureRecognizer(orRecog)
        
        let ndRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupNdExtra))
        ndRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 15)!.addGestureRecognizer(ndRecog)
        
        let nggRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupNggExtra))
        nggRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 18)!.addGestureRecognizer(nggRecog)
        
        let ngRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupNgExtra))
        ngRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 19)!.addGestureRecognizer(ngRecog)
        
        let nzRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupNzExtra))
        nzRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 24)!.addGestureRecognizer(nzRecog)
        
        let mvRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupMvExtra))
        mvRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 27)!.addGestureRecognizer(mvRecog)
        
        let mbRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupMbExtra))
        mbRecog.cancelsTouchesInView = false
        getKey(from: .latin, tag: 29)!.addGestureRecognizer(mbRecog)
        
        
        let percentRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupPercentExtra))
        percentRecog.cancelsTouchesInView = false
        getKey(from: .numMark, tag: 4)!.addGestureRecognizer(percentRecog)
        
        let hyphenBarRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupHyphenBarExtra))
        hyphenBarRecog.cancelsTouchesInView = false
        getKey(from: .numMark, tag: 11)!.addGestureRecognizer(hyphenBarRecog)
        
        let dashRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupDashExtra))
        dashRecog.cancelsTouchesInView = false
        getKey(from: .numMark, tag: 13)!.addGestureRecognizer(dashRecog)
        
        let sectionRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupSectionExtra))
        sectionRecog.cancelsTouchesInView = false
        getKey(from: .numMark, tag: 15)!.addGestureRecognizer(sectionRecog)
        
        let quoteRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupquoteExtra))
        quoteRecog.cancelsTouchesInView = false
        getKey(from: .numMark, tag: 20)!.addGestureRecognizer(quoteRecog)
        
        let periodRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupPeriodExtra))
        periodRecog.cancelsTouchesInView = false
        getKey(from: .numMark, tag: 21)!.addGestureRecognizer(periodRecog)
        
        let questionRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupQuestionExtra))
        questionRecog.cancelsTouchesInView = false
        getKey(from: .numMark, tag: 23)!.addGestureRecognizer(questionRecog)
        
        let exclamationRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupExclamationExtra))
        exclamationRecog.cancelsTouchesInView = false
        getKey(from: .numMark, tag: 24)!.addGestureRecognizer(exclamationRecog)
    }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    // MARK:- KeyPress
    
    @objc func keyTouchedDown(sender: UIButton) {
        Const.isExtra = false
        
        AudioServicesPlaySystemSound(1104)
    }
    
    @objc func deleteKeyTouchedDown(sender: AnyObject) {
        AudioServicesPlaySystemSound(1155)
    }
    
    @objc func otherKeyTouchedDown(sender: AnyObject) {
        AudioServicesPlaySystemSound(1156)
    }
    
    //    @objc func shiftPressed(recog: UITapGestureRecognizer) {
    //
    //        print("shiftpressed")
    //
    //        if Const.isShift {
    //            Const.isShift = !Const.isShift
    //            Const.isShiftSucceeding = false
    //        } else {
    //            if recog.numberOfTapsRequired == 1 {
    //                Const.isShift = !Const.isShift
    //            } else if recog.numberOfTapsRequired == 2 {
    //                Const.isShift = !Const.isShift
    //                Const.isShiftSucceeding = true
    //            }
    //        }
    //
    //        setKeys(Const.isShift)
    //    }
    
    @objc func latinKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        if key.tag<=33 { // insertText
            var str = ""
            
            if Const.isExtra {
                str = Const.latinExtraList[Const.isShift]![key.tag]!
            } else {
                str = Const.latinList[Const.isShift]![key.tag-1]
            }
            
            if Const.isShift {
                Const.isShift = false
                setKeys(.latin, false)
            }
            
            //                if !Const.isShiftSucceeding {
            //                    Const.isShift = false
            //
            //                    setKeys(false)
            //                }
            
            self.textDocumentProxy.insertText(str)
        }
        
        if key.tag == 34 {
            Const.isShift = !Const.isShift
            setKeys(.latin, Const.isShift)
        }
        
        if key.tag == 36 {
            if Const.isShift {
                Const.isShift = false
                setKeys(.latin, false)
            }
            
            latinKeyboard.removeFromSuperview()
            
            view.addSubview(cyrillicKeyboard)
            cyrillicKeyboard.fillSuperView()
        }
    }
    
    @objc func cyrillicKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        if key.tag<=28 { // insertText
            var str = ""
            
            if key.tag == 26 {
                str = String(UnicodeScalar(774)!)
            } else {
                str = Const.cyrillicList[Const.isShift]![key.tag-1]
            }
            
            if Const.isShift {
                Const.isShift = false
                setKeys(.cyrillic, false)
            }
            
            self.textDocumentProxy.insertText(str)
        }
        
        if key.tag == 29 {
            Const.isShift = !Const.isShift
            setKeys(.cyrillic, Const.isShift)
        }
        
        if key.tag == 31 {
            if Const.isShift {
                Const.isShift = false
                setKeys(.cyrillic, false)
            }
            
            cyrillicKeyboard.removeFromSuperview()
            
            view.addSubview(numMarkKeyboard)
            numMarkKeyboard.fillSuperView()
        }
    }
    
    @objc func numMarkKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        if key.tag<=28 { // insertText
            var str = ""
            
            if Const.isExtra {
                str = Const.numMarkExtraList[Const.isShift]![key.tag]!
            } else {
                str = Const.numMarkList[Const.isShift]![key.tag-1]
            }
            
            self.textDocumentProxy.insertText(str)
        }
        
        if key.tag == 29 {
            Const.isShift = !Const.isShift
            setKeys(.numMark, Const.isShift)
        }
        
        if key.tag == 31 {
            if Const.isShift {
                Const.isShift = false
                setKeys(.numMark, false)
            }
            
            numMarkKeyboard.removeFromSuperview()
            
            view.addSubview(latinKeyboard)
            latinKeyboard.fillSuperView()
        }
    }
    
    @objc func deleteChr() {
        self.textDocumentProxy.deleteBackward()
    }
    
    // MARK:- LongKeyPress
    
    @objc func popupQExtra(recog: UILongPressGestureRecognizer) { // 被せている
        if recog.state == .began {
            showPopup(recog: recog, "Q", "q")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNgqExtra(recog: UILongPressGestureRecognizer) { // 被せている
        if recog.state == .began {
            showPopup(recog: recog, "Q̆", "q̆")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupErExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "Ê", "ê")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupIExtra(recog: UILongPressGestureRecognizer) {
        if Const.isShift {
            if recog.state == .began {
                showPopup(recog: recog, "Y", nil)
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupOrExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "Ô", "ô")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNdExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "D̆", "d̆")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNggExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "Ğ", "ğ")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNgExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "Ñ", "ñ")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNzExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "Z̆", "z̆")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupMvExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "V̆", "v̆")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupMbExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "B̆", "b̆")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    // MARK: Num + Mark
    
    @objc func popupPercentExtra(recog: UILongPressGestureRecognizer) { // 被せている
        if Const.isShift {
            if recog.state == .began {
                showPopup(recog: recog, "‰", nil)
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupHyphenBarExtra(recog: UILongPressGestureRecognizer) { // 被せている
        if recog.state == .began {
            showPopup(recog: recog, "‾", "•")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupDashExtra(recog: UILongPressGestureRecognizer) { // 被せている
        if !Const.isShift {
            if recog.state == .began {
                showPopup(recog: recog, nil, "—")
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupSectionExtra(recog: UILongPressGestureRecognizer) { // 被せている
        if Const.isShift {
            if recog.state == .began {
                showPopup(recog: recog, "¶", nil)
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupquoteExtra(recog: UILongPressGestureRecognizer) { // 被せている
        if !Const.isShift {
            if recog.state == .began {
                showPopup(recog: recog, nil, "'")
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupPeriodExtra(recog: UILongPressGestureRecognizer) { // 被せている
        if recog.state == .began {
            showPopup(recog: recog, "…", "…")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupQuestionExtra(recog: UILongPressGestureRecognizer) { // 被せている
        if recog.state == .began {
            showPopup(recog: recog, "⸮", "⸮")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupExclamationExtra(recog: UILongPressGestureRecognizer) { // 被せている
        if recog.state == .began {
            showPopup(recog: recog, "‽", "‽")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    // MARK:- Methods
    
    func setKeys(_ type: keyboardType, _ isShift: Bool) {
        if type == .latin {
            for stack in self.latinKeyboard.subviews {
                for keytobe in stack.subviews  {
                    let key = keytobe as! UIButton
                    UIView.performWithoutAnimation {
                        switch key.tag {
                        case 1...31: key.setTitle(Const.latinList[isShift]![key.tag-1], for: .normal)
                        case 34: key.setTitle(isShift ? "⇪": "⇧", for: .normal)
                        default: break
                        }
                        key.layoutIfNeeded()
                    }
                }
            }
        } else if type == .cyrillic {
            for stack in self.cyrillicKeyboard.subviews {
                for keytobe in stack.subviews  {
                    if let key = keytobe as? UIButton {
                        UIView.performWithoutAnimation {
                            switch key.tag {
                            case 1...19: key.setTitle(Const.cyrillicList[isShift]![key.tag-1], for: .normal)
                            case 29: key.setTitle(isShift ? "⇪": "⇧", for: .normal)
                            default: break
                            }
                            key.layoutIfNeeded()
                        }
                    } else {
                        for keys in keytobe.subviews {
                            let key = keys as! UIButton
                            
                            UIView.performWithoutAnimation {
                                switch key.tag {
                                case 20...26: key.setTitle(Const.cyrillicList[isShift]![key.tag-1], for: .normal)
                                default: break
                                }
                                key.layoutIfNeeded()
                            }
                        }
                    }
                }
                
            }
        } else {
            for stack in self.numMarkKeyboard.subviews {
                for keytobe in stack.subviews  {
                    if let key = keytobe as? UIButton {
                        UIView.performWithoutAnimation {
                            switch key.tag {
                            case 1...20: key.setTitle(Const.numMarkList[isShift]![key.tag-1], for: .normal)
                            case 29: key.setTitle(isShift ? "123": "#+=", for: .normal)
                            default: break
                            }
                            key.layoutIfNeeded()
                        }
                    } else {
                        for keys in keytobe.subviews {
                            let key = keys as! UIButton
                            
                            UIView.performWithoutAnimation {
                                switch key.tag {
                                case 21...26: key.setTitle(Const.numMarkList[isShift]![key.tag-1], for: .normal)
                                default: break
                                }
                                key.layoutIfNeeded()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getKey(from type: keyboardType, tag: Int) -> UIButton? {
        if type == .latin {
            for stack in self.latinKeyboard.subviews {
                for keytobe in stack.subviews {
                    if keytobe.tag == tag {
                        let key = keytobe as! UIButton
                        return key
                    } else {
                        continue
                    }
                }
            }
        } else if type == .cyrillic {
            for stack in self.cyrillicKeyboard.subviews {
                for keytobe in stack.subviews {
                    if keytobe is UIButton {
                        if keytobe.tag == tag {
                            let key = keytobe as! UIButton
                            return key
                        } else {
                            continue
                        }
                    } else {
                        for keytobe2 in keytobe.subviews {
                            if keytobe2.tag == tag {
                                let key = keytobe2 as! UIButton
                                return key
                            } else {
                                continue
                            }
                        }
                    }
                    
                }
            }
        } else {
            for stack in self.numMarkKeyboard.subviews {
                for keytobe in stack.subviews {
                    if keytobe is UIButton {
                        if keytobe.tag == tag {
                            let key = keytobe as! UIButton
                            return key
                        } else {
                            continue
                        }
                    } else {
                        for keytobe2 in keytobe.subviews {
                            if keytobe2.tag == tag {
                                let key = keytobe2 as! UIButton
                                return key
                            } else {
                                continue
                            }
                        }
                    }
                    
                }
            }
        }
        
        return nil
    }
    
    func showPopup(recog: UIGestureRecognizer, _ t: String?, _ f: String?) {
        Const.isExtra = true
        
        let button = recog.view as! UIButton
        
        var popupFrame: CGRect
        var textLabelFrame: CGRect
        
        popupFrame = CGRect(x: 0 , y: 0, width: button.frame.size.width, height: button.frame.size.height)
        textLabelFrame = CGRect(x: 3, y: 3, width: popupFrame.size.width-6, height: popupFrame.size.height-6)
        
        let popup = UIView(frame: popupFrame)
        popup.backgroundColor = .black
        popup.layer.cornerRadius = 5
        
        let textLabel = UILabel()
        textLabel.frame = textLabelFrame
        textLabel.text = Const.isShift ? t : f
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 23)
        textLabel.textColor = .white
        
        popup.addSubview(textLabel)
        
        button.addSubview(popup)
    }
}
