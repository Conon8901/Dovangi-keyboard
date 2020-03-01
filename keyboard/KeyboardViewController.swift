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
    
    enum ScriptType {
        case latin
        case cyrillic
        case numMark
    }
    
    struct Const {
        static var isShift = false
        static var isShiftSucceeding = false
        static var isExtra = false
        static var lastShiftDate = Date()
        
        static let latinList = [true: ["Ƣ", "Ɋ", "E", "Ɛ", "T", "Ł", "U", "İ", "O", "Ɔ", "P", "A", "S", "D", "Ɗ", "F", "G", "Ɠ", "Ŋ", "K", "L", "R", "Z", "Ȥ", "X", "V", "Ʋ", "B", "Ɓ", "N", "M", " ", "\n"], false: ["ƣ", "ɋ", "e", "ɛ", "t", "ł", "u", "i", "o", "ɔ", "p", "a", "s", "d", "ɗ", "f", "g", "ɠ", "ŋ", "k", "l", "r", "z", "ȥ", "x", "v", "ʋ", "b", "ɓ", "n", "m", " ", "\n"]]
        static let latinExtraList = [true: [1: "Q", 2: "Q̇", 4: "Ê", 8: "Y", 10: "Ô", 15: "Ḍ", 18: "Ġ", 19: "Ñ", 24: "Ẓ", 27: "Ṿ", 29: "Ḅ"], false: [1: "q", 2: "q̇", 4: "ê", 10: "ô", 15: "ḍ", 18: "ġ", 19: "ñ", 24: "ẓ", 27: "ṿ", 29: "ḅ"]]
        static let cyrillicList = [true: ["У", "К", "Е", "Н", "Г", "З", "Х", "Ъ", "Ң", "Ғ", "Ф", "В", "А", "П", "О", "Л", "Д", "Э", "Ԓ", "С", "М", "И", "Т", "Б", "Ә", "◌̆", " ", "\n"], false: ["у", "к", "е", "н", "г", "з", "х", "ъ", "ң", "ғ", "ф", "в", "а", "п", "о", "л", "д", "э", "ԓ", "с", "м", "и", "т", "б", "ә", "◌̆", " ", "\n"]]
        static let numMarkList = [true: ["[", "]", "#", "†", "^", "+", "−", "×", "÷", "=", "_", "<", ">", "ᵐ", "ⁿ", "ᵑ", "ɡ", "ɣ", "ɬ", "ɮ", ".", ",", "?", "!", "«", "»", " ", "\n"], false: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "~", "–", "/", ":", ";", "(", ")", "*", "\"", ".", ",", "?", "!", "«", "»", " ", "\n"]]
        static let numMarkExtraList = [true: [4: "‰", 11: "‾", 21: "…", 23: "⸮", 24: "‽"], false: [11: "•", 13: "—", 20: "'", 21: "…", 23: "⸮", 24: "‽"]]
        
        static let keyboardHeights: [CGFloat:CGFloat] = [568.0: 216.0, 667.0: 216.0, 736.0: 226.0, 812.0: 216.0, 896.0: 226.0]
        /*
         568.0: 5s, SE
         667.0: 6, 6s, 7, 8
         736.0: 6 plus, 6s plus, 7 plus, 8 plus
         812.0: X, XS
         896.0: XR, XS MAX
         */
        
    }
    
    var latinKeyboard: UIView!
    var cyrillicKeyboard: UIView!
    var numMarkKeyboard: UIView!
    
    var deleteTimer: Timer!
    
    // MARK:- Bases
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // キーボードの高さ指定
        let constraintH = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: Const.keyboardHeights[UIScreen.main.bounds.size.height]!)
        constraintH.priority = UILayoutPriority(rawValue: 990)
        self.view.addConstraint(constraintH)
        
        // Latin
        latinKeyboard = UINib(nibName: "Latin", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        latinKeyboard.frame = view.frame
        latinKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in self.latinKeyboard.subviews {
            for keytobe in stack.subviews {
                let key = keytobe as! UIButton
                key.roundedCornerise()
                
                // function
                if key.tag == 35 { // delete key
                    key.addTarget(self, action: #selector(deleteDown), for: .touchDown)
                    key.addTarget(self, action: #selector(deleteUp), for: [.touchUpInside, .touchUpOutside])
                } else if key.tag <= 36 {
                    key.addTarget(self, action: #selector(latinKeyPressed), for: .touchUpInside)
                }
                
                // colour
                if key.tag == 32 { // space
                    key.addTarget(self, action: #selector(keyGreyen), for: .touchDown)
                    key.addTarget(self, action: #selector(keyWhiten), for: [.touchUpInside, .touchUpOutside])
                }
                
                if key.tag == 33 || key.tag == 35 || key.tag == 37 { // return, delete, nextKeyboard
                    key.addTarget(self, action: #selector(keyWhiten), for: .touchDown)
                    key.addTarget(self, action: #selector(keyGreyen), for: [.touchUpInside, .touchUpOutside])
                }
                
                // sound
                if key.tag == 35 {
                    key.addTarget(self, action: #selector(deleteKeySoundSet), for: .touchDown)
                } else {
                    if key.tag >= 32 {
                        key.addTarget(self, action: #selector(otherKeySoundSet), for: .touchDown)
                    } else {
                        key.addTarget(self, action: #selector(keysoundSet), for: .touchDown)
                    }
                }
            }
        }
        
        // Cyrillic
        cyrillicKeyboard = UINib(nibName: "Cyrillic", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        cyrillicKeyboard.frame = view.frame
        cyrillicKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in self.cyrillicKeyboard.subviews {
            for keytobe in stack.subviews {
                if let key = keytobe as? UIButton {
                    key.roundedCornerise()
                    
                    // function
                    if key.tag == 30 {
                        key.addTarget(self, action: #selector(deleteDown), for: .touchDown)
                        key.addTarget(self, action: #selector(deleteUp), for: [.touchUpInside, .touchUpOutside])
                    } else {
                        key.addTarget(self, action: #selector(cyrillicKeyPressed), for: .touchUpInside)
                    }
                    
                    // colour
                    if key.tag == 27 {
                        key.addTarget(self, action: #selector(keyGreyen), for: .touchDown)
                        key.addTarget(self, action: #selector(keyWhiten), for: [.touchUpInside, .touchUpOutside])
                    }
                    
                    if key.tag == 28 || key.tag == 30 || key.tag == 32 {
                        key.addTarget(self, action: #selector(keyWhiten), for: .touchDown)
                        key.addTarget(self, action: #selector(keyGreyen), for: [.touchUpInside, .touchUpOutside])
                    }
                    
                    // sound
                    if key.tag == 30 {
                        key.addTarget(self, action: #selector(deleteKeySoundSet), for: .touchDown)
                    } else {
                        if key.tag >= 27 {
                            key.addTarget(self, action: #selector(otherKeySoundSet), for: .touchDown)
                        } else {
                            key.addTarget(self, action: #selector(keysoundSet), for: .touchDown)
                        }
                    }
                } else {
                    for keys in keytobe.subviews {
                        let key = keys as! UIButton
                        key.roundedCornerise()
                        
                        key.addTarget(self, action: #selector(cyrillicKeyPressed), for: .touchUpInside)
                        
                        key.addTarget(self, action: #selector(keysoundSet), for: .touchDown)
                    }
                }
            }
        }
        
        // Num + Mark
        numMarkKeyboard = UINib(nibName: "NumMark", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        numMarkKeyboard.frame = view.frame
        numMarkKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        for stack in self.numMarkKeyboard.subviews {
            for keytobe in stack.subviews {
                if let key = keytobe as? UIButton {
                    key.roundedCornerise()
                    
                    // function
                    if key.tag == 30 {
                        key.addTarget(self, action: #selector(deleteDown), for: .touchDown)
                        key.addTarget(self, action: #selector(deleteUp), for: [.touchUpInside, .touchUpOutside])
                    } else {
                        key.addTarget(self, action: #selector(numMarkKeyPressed), for: .touchUpInside)
                    }
                    
                    // colour
                    if key.tag == 27 {
                        key.addTarget(self, action: #selector(keyGreyen), for: .touchDown)
                        key.addTarget(self, action: #selector(keyWhiten), for: [.touchUpInside, .touchUpOutside])
                    }
                    
                    if key.tag == 28 || key.tag == 30 || key.tag == 32 {
                        key.addTarget(self, action: #selector(keyWhiten), for: .touchDown)
                        key.addTarget(self, action: #selector(keyGreyen), for: [.touchUpInside, .touchUpOutside])
                    }
                    
                    // sound
                    
                    
                    if key.tag == 30 {
                        key.addTarget(self, action: #selector(deleteKeySoundSet), for: .touchDown)
                    } else {
                        if key.tag >= 27 {
                            key.addTarget(self, action: #selector(otherKeySoundSet), for: .touchDown)
                        } else {
                            key.addTarget(self, action: #selector(keysoundSet), for: .touchDown)
                        }
                    }
                } else {
                    for keys in keytobe.subviews {
                        let key = keys as! UIButton
                        key.roundedCornerise()
                        
                        key.addTarget(self, action: #selector(numMarkKeyPressed), for: .touchUpInside)
                        
                        key.addTarget(self, action: #selector(keysoundSet), for: .touchDown)
                    }
                }
            }
        }
        
        // Set Keyboard
        view.addSubview(latinKeyboard)
        latinKeyboard.fillSuperView()
        
        // Perform custom UI setup here
        getKey(from: .latin, tag: 37)!.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        getKey(from: .cyrillic, tag: 32)!.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        getKey(from: .numMark, tag: 32)!.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        // Substitution Setting
        addLongPressGesture(#selector(popupQExtra), to: getKey(from: .latin, tag: 1)!)
        addLongPressGesture(#selector(popupNgqExtra), to: getKey(from: .latin, tag: 2)!)
        addLongPressGesture(#selector(popupErExtra), to: getKey(from: .latin, tag: 4)!)
        addLongPressGesture(#selector(popupIExtra), to: getKey(from: .latin, tag: 2)!)
        addLongPressGesture(#selector(popupIExtra), to: getKey(from: .latin, tag: 8)!)
        addLongPressGesture(#selector(popupOrExtra), to: getKey(from: .latin, tag: 10)!)
        addLongPressGesture(#selector(popupNdExtra), to: getKey(from: .latin, tag: 15)!)
        addLongPressGesture(#selector(popupNggExtra), to: getKey(from: .latin, tag: 18)!)
        addLongPressGesture(#selector(popupNgExtra), to: getKey(from: .latin, tag: 19)!)
        addLongPressGesture(#selector(popupNzExtra), to: getKey(from: .latin, tag: 24)!)
        addLongPressGesture(#selector(popupMvExtra), to: getKey(from: .latin, tag: 27)!)
        addLongPressGesture(#selector(popupMbExtra), to: getKey(from: .latin, tag: 29)!)
        
        addLongPressGesture(#selector(popupHyphenExtra), to: getKey(from: .numMark, tag: 11)!)
        addLongPressGesture(#selector(popupDashExtra), to: getKey(from: .numMark, tag: 13)!)
        addLongPressGesture(#selector(popupColonExtra), to: getKey(from: .numMark, tag: 15)!)
        addLongPressGesture(#selector(popupQuoteExtra), to: getKey(from: .numMark, tag: 20)!)
        addLongPressGesture(#selector(popupPeriodExtra), to: getKey(from: .numMark, tag: 21)!)
        addLongPressGesture(#selector(popupQuestionExtra), to: getKey(from: .numMark, tag: 23)!)
        addLongPressGesture(#selector(popupExclamationExtra), to: getKey(from: .numMark, tag: 24)!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !self.needsInputModeSwitchKey {
            getKey(from: .latin, tag: 37)?.removeFromSuperview()
            getKey(from: .cyrillic, tag: 32)?.removeFromSuperview()
            getKey(from: .numMark, tag: 32)?.removeFromSuperview()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("transition \(size)")
        print("YOU DID IT!!!")
    }
    
    // MARK:- KeyPress
    
    @objc func keysoundSet(sender: AnyObject) {
        Const.isExtra = false
        
        AudioServicesPlaySystemSound(1104)
    }
    
    @objc func deleteKeySoundSet(sender: AnyObject) {
        AudioServicesPlaySystemSound(1155)
    }
    
    @objc func otherKeySoundSet(sender: AnyObject) {
        AudioServicesPlaySystemSound(1156)
    }
    
    // MARK: For Each Keyboard
    @objc func latinKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        if key.tag<=33 { // insertText
            var str = ""
            
            if Const.isExtra {
                str = Const.latinExtraList[Const.isShift]![key.tag]!
            } else {
                str = Const.latinList[Const.isShift]![key.tag-1]
            }
            
            if Const.isShift && !Const.isShiftSucceeding && key.tag <= 31 {
                Const.isShift = false
                setKeys(.latin, false)
            }
            
            self.textDocumentProxy.insertText(str)
        }
        
        if key.tag == 34 {
            if Const.isShift {
                if Date().timeIntervalSince(Const.lastShiftDate) <= 0.35 {
                    Const.isShiftSucceeding = true
                    
                    UIView.performWithoutAnimation {
                        getKey(from: .latin, tag: 34)!.setTitle("⇪", for: .normal)
                        key.layoutIfNeeded()
                    }
                } else {
                    Const.isShift = false
                    setKeys(.latin, false)
                }
            } else {
                Const.lastShiftDate = Date()
                
                Const.isShift = true
                Const.isShiftSucceeding = false
                setKeys(.latin, true)
            }
        }
        
        if key.tag == 36 {
            if Const.isShift {
                Const.isShift = false
                Const.isShiftSucceeding = false
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
                if self.textDocumentProxy.documentContextBeforeInput?.last == "б" {
                    str = String(UnicodeScalar(815)!)
                } else {
                    str = String(UnicodeScalar(774)!)
                }
            } else {
                str = Const.cyrillicList[Const.isShift]![key.tag-1]
            }
            
            if Const.isShift && !Const.isShiftSucceeding && key.tag <= 26 {
                Const.isShift = false
                setKeys(.cyrillic, false)
            }
            
            self.textDocumentProxy.insertText(str)
        }
        
        if key.tag == 29 {
            if Const.isShift {
                if Date().timeIntervalSince(Const.lastShiftDate) <= 0.35 {
                    Const.isShiftSucceeding = true
                    
                    UIView.performWithoutAnimation {
                        getKey(from: .cyrillic, tag: 29)!.setTitle("⇪", for: .normal)
                        key.layoutIfNeeded()
                    }
                } else {
                    Const.isShift = false
                    setKeys(.cyrillic, false)
                }
            } else {
                Const.lastShiftDate = Date()
                
                Const.isShift = true
                Const.isShiftSucceeding = false
                setKeys(.cyrillic, true)
            }
        }
        
        if key.tag == 31 {
            if Const.isShift {
                Const.isShift = false
                Const.isShiftSucceeding = false
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
    
    // MARK: For Some Keys
    @objc func keyGreyen(sender: AnyObject) {
        let key = sender as! UIButton
        key.backgroundColor = UIColor(red: 168/255, green: 176/255, blue: 187/255, alpha: 1)
    }
    
    @objc func keyWhiten(sender: AnyObject) {
        let key = sender as! UIButton
        key.backgroundColor = .white
    }
    
    @objc func deleteDown(sender: AnyObject) {
        self.textDocumentProxy.deleteBackward()
        
        let deleteStartTime = Date()
        deleteTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            if self.textDocumentProxy.hasText {
                let span: TimeInterval = timer.fireDate.timeIntervalSince(deleteStartTime)
                if span > 0.4 {
                    self.textDocumentProxy.deleteBackward()
                    
                    AudioServicesPlaySystemSound(1155)
                }
            }
        })
    }
    
    @objc func deleteUp(sender: AnyObject) {
        deleteTimer.invalidate()
    }
    
    // MARK:- LongKeyPress
    
    @objc func popupQExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "Q", "q")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNgqExtra(recog: UILongPressGestureRecognizer) {
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
    
    @objc func popupHyphenExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "‾", "•")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupDashExtra(recog: UILongPressGestureRecognizer) {
        if !Const.isShift {
            if recog.state == .began {
                showPopup(recog: recog, nil, "—")
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupColonExtra(recog: UILongPressGestureRecognizer) {
        if !Const.isShift {
            if recog.state == .began {
                showPopup(recog: recog, nil, ";")
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupQuoteExtra(recog: UILongPressGestureRecognizer) {
        if !Const.isShift {
            if recog.state == .began {
                showPopup(recog: recog, nil, "'")
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupPeriodExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "…", "…")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupQuestionExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "⸮", "⸮")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupExclamationExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "‽", "‽")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    // MARK:- Methods
    
    func setKeys(_ type: ScriptType, _ isShift: Bool) {
        if type == .latin {
            for stack in self.latinKeyboard.subviews {
                for keytobe in stack.subviews  {
                    let key = keytobe as! UIButton
                    UIView.performWithoutAnimation {
                        switch key.tag {
                        case 1...31: key.setTitle(Const.latinList[isShift]![key.tag-1], for: .normal)
                        case 34:
                            key.setTitle("⇧", for: .normal)
                            key.backgroundColor = isShift ? .white : UIColor(red: 168/255, green: 176/255, blue: 187/255, alpha: 1)
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
                            case 29:
                                key.setTitle("⇧", for: .normal)
                                key.backgroundColor = isShift ? .white : UIColor(red: 168/255, green: 176/255, blue: 187/255, alpha: 1)
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
    
    func getKey(from type: ScriptType, tag: Int) -> UIButton? {
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
        textLabel.font = UIFont.systemFont(ofSize: 25)
        textLabel.textColor = .white
        
        popup.addSubview(textLabel)
        
        button.addSubview(popup)
    }
    
    func addLongPressGesture(_ action: Selector, to button: UIButton) {
        let recog = UILongPressGestureRecognizer(target: self, action: action)
        recog.cancelsTouchesInView = false
        button.addGestureRecognizer(recog)
    }
}
