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
    
    // MARK:- Lets, Vars, etc
    
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
        static let latinList =
            [true: ["Ƣ", "E", "Ɛ", "T", "Ł", "U", "İ", "O", "Ɔ", "P", "A", "S", "D", "F", "G", "Ŋ", "K", "L", "R", "Z", "X", "V", "B", "N", "M", "◌̇", " ", "\n"],
             false: ["ƣ", "e", "ɛ", "t", "ł", "u", "i", "o", "ɔ", "p", "a", "s", "d", "f", "g", "ŋ", "k", "l", "r", "z", "x", "v", "b", "n", "m", "◌̇", " ", "\n"]]
        static let latinExtraList =
            [true: [1: "Q", 3: "Ê", 7: "Y", 9: "Ô", 16: "Ñ"],
             false: [1: "q", 3: "ê", 9: "ô", 16: "ñ"]]
        static let latinFunctionList: [KeyFuction] = [.chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .space, .newline, .shift, .delete, .changeType, .nextKeyboard]
        
        static let cyrillicList =
            [true: ["У", "К", "Е", "Н", "Г", "З", "Х", "Ъ", "Ң", "Ғ", "Ф", "В", "А", "П", "О", "Л", "Д", "Э", "Ԓ", "С", "М", "И", "Т", "Б", "Ә", "◌̆", " ", "\n"],
             false: ["у", "к", "е", "н", "г", "з", "х", "ъ", "ң", "ғ", "ф", "в", "а", "п", "о", "л", "д", "э", "ԓ", "с", "м", "и", "т", "б", "ә", "◌̆", " ", "\n"]]
        static let cyrillicFunctionList: [KeyFuction] = [.chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .chr, .space, .newline, .shift, .delete, .changeType, .nextKeyboard]
        
        static let numMarkList =
            [true: ["[", "]", "#", "†", "^", "+", "−", "×", "÷", "=", "_", "<", ">", "ᵐ", "ⁿ", "ᵑ", "ɡ", "ɣ", "ɬ", "ɮ", ".", ",", "?", "!", "«", "»", " ", "\n"],
             false: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "~", "–", "/", ":", ";", "(", ")", "*", "\"", ".", ",", "?", "!", "«", "»", " ", "\n"]]
        static let numMarkExtraList =
            [true: [4: "‰", 11: "‾", 21: "…", 23: "⸮", 24: "‽", 25: "‹", 26: "›"],
             false: [11: "•", 13: "—", 20: "'", 21: "…", 23: "⸮", 24: "‽", 25: "‹", 26: "›"]]
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
    }
    
    var latinKeyboard: UIView!
    var cyrillicKeyboard: UIView!
    var numMarkKeyboard: UIView!
    
    var deleteTimer: Timer!
    
    var constraintH = NSLayoutConstraint()
    
    // only for landscape
    var constraintTopL = NSLayoutConstraint()
    var constraintBottomL = NSLayoutConstraint()
    var constraintLeadingL = NSLayoutConstraint()
    var constraintTrailingL = NSLayoutConstraint()
    var constraintcentreXL = NSLayoutConstraint()
    var constraintWidthL = NSLayoutConstraint()
    
    var constraintTopC = NSLayoutConstraint()
    var constraintBottomC = NSLayoutConstraint()
    var constraintLeadingC = NSLayoutConstraint()
    var constraintTrailingC = NSLayoutConstraint()
    var constraintcentreXC = NSLayoutConstraint()
    var constraintWidthC = NSLayoutConstraint()
    
    var constraintTopN = NSLayoutConstraint()
    var constraintBottomN = NSLayoutConstraint()
    var constraintLeadingN = NSLayoutConstraint()
    var constraintTrailingN = NSLayoutConstraint()
    var constraintcentreXN = NSLayoutConstraint()
    var constraintWidthN = NSLayoutConstraint()
    
    var constraintsForCommon = [ScriptType:[NSLayoutConstraint]]()
    var constraintsForPortrait = [ScriptType:[NSLayoutConstraint]]()
    var constraintsForLandscape = [ScriptType:[NSLayoutConstraint]]()
    
    var isShift = false
    var isShiftSucceeding = false
    var isExtra = false
    var lastShiftDate = Date()
    var currentKeyboardType = ScriptType.latin
    
    // MARK:- Bases
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboardXibs()
        
        // Latin
        for key in self.latinKeyboard.subButtons {
            key.setShadow()
            
            switch Const.latinFunctionList[key.tag-1] {
            case .chr:
                key.addTarget(self, action: #selector(latinChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setKeysound), for: .touchDown)
            case .space:
                key.addTarget(self, action: #selector(latinChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(greyenKey), for: .touchDown)
                key.addTarget(self, action: #selector(whitenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .newline:
                key.addTarget(self, action: #selector(latinChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(whitenKey), for: .touchDown)
                key.addTarget(self, action: #selector(greyenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .shift:
                key.addTarget(self, action: #selector(latinShiftKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .delete:
                key.addTarget(self, action: #selector(deleteDown), for: .touchDown)
                key.addTarget(self, action: #selector(deleteUp), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(whitenKey), for: .touchDown)
                key.addTarget(self, action: #selector(greyenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setDeleteKeySound), for: .touchDown)
            case .changeType:
                key.addTarget(self, action: #selector(latinChangeTypeKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .nextKeyboard:
                key.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                
                key.addTarget(self, action: #selector(whitenKey), for: .touchDown)
                key.addTarget(self, action: #selector(greyenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            }
        }
        
        // Cyrillic
        for key in self.cyrillicKeyboard.subButtons {
            key.setShadow()
            
            // function
            switch Const.cyrillicFunctionList[key.tag-1] {
            case .chr:
                key.addTarget(self, action: #selector(cyrillicChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setKeysound), for: .touchDown)
            case .space:
                key.addTarget(self, action: #selector(cyrillicChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(greyenKey), for: .touchDown)
                key.addTarget(self, action: #selector(whitenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .newline:
                key.addTarget(self, action: #selector(cyrillicChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(whitenKey), for: .touchDown)
                key.addTarget(self, action: #selector(greyenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .shift:
                key.addTarget(self, action: #selector(cyrillicShiftKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .delete:
                key.addTarget(self, action: #selector(deleteDown), for: .touchDown)
                key.addTarget(self, action: #selector(deleteUp), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(whitenKey), for: .touchDown)
                key.addTarget(self, action: #selector(greyenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setDeleteKeySound), for: .touchDown)
            case .changeType:
                key.addTarget(self, action: #selector(cyrillicChangeTypeKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .nextKeyboard:
                key.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                
                key.addTarget(self, action: #selector(whitenKey), for: .touchDown)
                key.addTarget(self, action: #selector(greyenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            }
        }
        
        // Num + Mark
        for key in self.numMarkKeyboard.subButtons {
            key.setShadow()
            
            switch Const.numMarkFunctionList[key.tag-1] {
            case .chr:
                key.addTarget(self, action: #selector(numMarkChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setKeysound), for: .touchDown)
            case .space:
                key.addTarget(self, action: #selector(numMarkChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(greyenKey), for: .touchDown)
                key.addTarget(self, action: #selector(whitenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .newline:
                key.addTarget(self, action: #selector(numMarkChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(whitenKey), for: .touchDown)
                key.addTarget(self, action: #selector(greyenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .shift:
                key.addTarget(self, action: #selector(numMarkShiftKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .delete:
                key.addTarget(self, action: #selector(deleteDown), for: .touchDown)
                key.addTarget(self, action: #selector(deleteUp), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(whitenKey), for: .touchDown)
                key.addTarget(self, action: #selector(greyenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setDeleteKeySound), for: .touchDown)
            case .changeType:
                key.addTarget(self, action: #selector(numMarkChangeTypeKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .nextKeyboard:
                key.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                
                key.addTarget(self, action: #selector(whitenKey), for: .touchDown)
                key.addTarget(self, action: #selector(greyenKey), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            }
        }
        
        // Set Keyboard
        constraintH = constraint(self.view, .height, constant: Const.keyboardHeights[UIScreen.main.bounds.size.height]!)
        constraintH.isActive = true
        
        constraintTopL = constraint(latinKeyboard, .top, to: self.view, .top)
        constraintBottomL = constraint(latinKeyboard, .bottom, to: self.view, .bottom)
        constraintLeadingL = constraint(latinKeyboard, .leading, to: self.view, .leading)
        constraintTrailingL = constraint(latinKeyboard, .trailing, to: self.view, .trailing)
        constraintcentreXL = constraint(latinKeyboard, .centerX, to: self.view, .centerX)
        constraintWidthL = constraint(latinKeyboard, .width, constant: 526)
        
        constraintTopC = constraint(cyrillicKeyboard, .top, to: self.view, .top)
        constraintBottomC = constraint(cyrillicKeyboard, .bottom, to: self.view, .bottom)
        constraintLeadingC = constraint(cyrillicKeyboard, .leading, to: self.view, .leading)
        constraintTrailingC = constraint(cyrillicKeyboard, .trailing, to: self.view, .trailing)
        constraintcentreXC = constraint(cyrillicKeyboard, .centerX, to: self.view, .centerX)
        constraintWidthC = constraint(cyrillicKeyboard, .width, constant: 526)
        
        constraintTopN = constraint(numMarkKeyboard, .top, to: self.view, .top)
        constraintBottomN = constraint(numMarkKeyboard, .bottom, to: self.view, .bottom)
        constraintLeadingN = constraint(numMarkKeyboard, .leading, to: self.view, .leading)
        constraintTrailingN = constraint(numMarkKeyboard, .trailing, to: self.view, .trailing)
        constraintcentreXN = constraint(numMarkKeyboard, .centerX, to: self.view, .centerX)
        constraintWidthN = constraint(numMarkKeyboard, .width, constant: 526)
        
        constraintsForCommon = [.latin: [constraintTopL, constraintBottomL],
                          .cyrillic: [constraintTopC, constraintBottomC],
                          .numMark: [constraintTopN, constraintBottomN]]
        constraintsForPortrait = [.latin: [constraintLeadingL, constraintTrailingL],
                          .cyrillic: [constraintLeadingC, constraintTrailingC],
                          .numMark: [constraintLeadingN, constraintTrailingN]]
        constraintsForLandscape = [.latin: [constraintcentreXL, constraintWidthL],
                          .cyrillic: [constraintcentreXC, constraintWidthC],
                          .numMark: [constraintcentreXN, constraintWidthN]]
        
        view.addSubview(latinKeyboard)
        
        setKeyboardConstraints(.latin)
        
        // Substitution Setting
        addLongPressGesture(#selector(popupQExtra), to: getKey(from: .latin, tag: 1)!)
        addLongPressGesture(#selector(popupErExtra), to: getKey(from: .latin, tag: 3)!)
        addLongPressGesture(#selector(popupIExtra), to: getKey(from: .latin, tag: 7)!)
        addLongPressGesture(#selector(popupOrExtra), to: getKey(from: .latin, tag: 9)!)
        addLongPressGesture(#selector(popupNgExtra), to: getKey(from: .latin, tag: 16)!)
        
        addLongPressGesture(#selector(popupHyphenExtra), to: getKey(from: .numMark, tag: 11)!)
        addLongPressGesture(#selector(popupDashExtra), to: getKey(from: .numMark, tag: 13)!)
        addLongPressGesture(#selector(popupLinearExtra), to: getKey(from: .numMark, tag: 20)!)
        addLongPressGesture(#selector(popupPeriodExtra), to: getKey(from: .numMark, tag: 21)!)
        addLongPressGesture(#selector(popupQuestionExtra), to: getKey(from: .numMark, tag: 23)!)
        addLongPressGesture(#selector(popupExclamationExtra), to: getKey(from: .numMark, tag: 24)!)
        addLongPressGesture(#selector(popupLeftAngleExtra), to: getKey(from: .numMark, tag: 25)!)
        addLongPressGesture(#selector(popupRightAngleExtra), to: getKey(from: .numMark, tag: 26)!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if !self.needsInputModeSwitchKey {
            getKey(from: .latin, tag: 37)?.removeFromSuperview()
            getKey(from: .cyrillic, tag: 32)?.removeFromSuperview()
            getKey(from: .numMark, tag: 32)?.removeFromSuperview()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) { // sizeはself.viewのsize
        setKeyboardConstraints(currentKeyboardType)
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var chrTextColor: UIColor
        var chrBgColor: UIColor
        var otrTextColor: UIColor
        var otrBgColor: UIColor
        var shadowColor: CGColor
        var bgColor: UIColor
        
        if self.textDocumentProxy.keyboardAppearance == .dark {
            chrTextColor = .white
            chrBgColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
            otrTextColor = .white
            otrBgColor = UIColor(red: 63/255, green: 63/255, blue: 64/255, alpha: 1)
            shadowColor = UIColor(red: 20/255, green: 20/255, blue: 21/255, alpha: 1).cgColor
            bgColor = UIColor(red: 34/255, green: 34/255, blue: 35/255, alpha: 1)
        } else {
            chrTextColor = .black
            chrBgColor = .white
            otrTextColor = .black
            otrBgColor = UIColor(red: 168/255, green: 176/255, blue: 187/255, alpha: 1)
            shadowColor = UIColor.gray.cgColor
            bgColor = UIColor(red: 207/255, green: 211/255, blue: 217/255, alpha: 1)
        }
        
        for i in 1...32 {
            if i <= 27 {
                getKey(from: .latin, tag: i)!.setTitleColor(chrTextColor, for: [])
                getKey(from: .latin, tag: i)!.backgroundColor = chrBgColor
            } else {
                getKey(from: .latin, tag: i)!.setTitleColor(otrTextColor, for: [])
                getKey(from: .latin, tag: i)!.backgroundColor = otrBgColor
            }
            
            getKey(from: .latin, tag: i)!.layer.shadowOffset = CGSize(width: 0.0, height: 1.2)
            getKey(from: .latin, tag: i)!.layer.shadowColor = shadowColor
            getKey(from: .latin, tag: i)!.layer.shadowOpacity = 0.8
            getKey(from: .latin, tag: i)!.layer.shadowRadius = 0
        }
        
        latinKeyboard.backgroundColor = bgColor
    }
    
    // MARK:- Funcs For Keys
    
    // MARK: keyPressed
    @objc func latinChrKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        
        var str = ""
        
        if key.tag == 26 {
            switch self.textDocumentProxy.documentContextBeforeInput?.last {
            case "B", "b", "D", "d": str = String(UnicodeScalar(803)!)
            default: str = String(UnicodeScalar(775)!)
            }
        } else {
            if isExtra {
                str = Const.latinExtraList[isShift]![key.tag]!
            } else {
                str = Const.latinList[isShift]![key.tag-1]
            }
        }
        
        if isShift && !isShiftSucceeding && key.tag <= 26 {
            isShift = false
            setKeys(.latin, false)
        }
        
        self.textDocumentProxy.insertText(str)
    }
    
    @objc func latinShiftKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        
        if isShift {
            if Date().timeIntervalSince(lastShiftDate) <= 0.35 {
                isShiftSucceeding = true
                
                UIView.performWithoutAnimation {
                    getKey(from: .latin, tag: 29)!.setTitle("⇪", for: .normal)
                    key.layoutIfNeeded()
                }
            } else {
                isShift = false
                setKeys(.latin, false)
            }
        } else {
            lastShiftDate = Date()
            
            isShift = true
            isShiftSucceeding = false
            setKeys(.latin, true)
        }
    }
    
    @objc func latinChangeTypeKeyPressed(sender: AnyObject) {
        if isShift {
            isShift = false
            isShiftSucceeding = false
            setKeys(.latin, false)
        }
        
        latinKeyboard.removeFromSuperview()
        
        view.addSubview(cyrillicKeyboard)
        
        currentKeyboardType = .cyrillic
        setKeyboardConstraints(.cyrillic)
    }
    
    @objc func cyrillicChrKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        
        var str = ""
        
        if key.tag == 26 {
            if self.textDocumentProxy.documentContextBeforeInput?.last == "б" {
                str = String(UnicodeScalar(815)!)
            } else {
                str = String(UnicodeScalar(774)!)
            }
        } else {
            str = Const.cyrillicList[isShift]![key.tag-1]
        }
        
        if isShift && !isShiftSucceeding && key.tag <= 26 {
            isShift = false
            setKeys(.cyrillic, false)
        }
        
        self.textDocumentProxy.insertText(str)
    }
    
    @objc func cyrillicShiftKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        
        if isShift {
            if Date().timeIntervalSince(lastShiftDate) <= 0.35 {
                isShiftSucceeding = true
                
                UIView.performWithoutAnimation {
                    getKey(from: .cyrillic, tag: 29)!.setTitle("⇪", for: .normal)
                    key.layoutIfNeeded()
                }
            } else {
                isShift = false
                setKeys(.cyrillic, false)
            }
        } else {
            lastShiftDate = Date()
            
            isShift = true
            isShiftSucceeding = false
            setKeys(.cyrillic, true)
        }
    }
    
    @objc func cyrillicChangeTypeKeyPressed(sender: AnyObject) {
        if isShift {
            isShift = false
            isShiftSucceeding = false
            setKeys(.cyrillic, false)
        }
        
        cyrillicKeyboard.removeFromSuperview()
        
        view.addSubview(numMarkKeyboard)
        
        currentKeyboardType = .numMark
        setKeyboardConstraints(.numMark)
    }
    
    @objc func numMarkChrKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        
        var str = ""
        
        if isExtra {
            str = Const.numMarkExtraList[isShift]![key.tag]!
        } else {
            str = Const.numMarkList[isShift]![key.tag-1]
        }
        
        self.textDocumentProxy.insertText(str)
    }
    
    @objc func numMarkShiftKeyPressed(sender: AnyObject) {
        isShift = !isShift
        setKeys(.numMark, isShift)
    }
    
    @objc func numMarkChangeTypeKeyPressed(sender: AnyObject) {
        if isShift {
            isShift = false
            setKeys(.numMark, false)
        }
        
        numMarkKeyboard.removeFromSuperview()
        
        view.addSubview(latinKeyboard)
        
        currentKeyboardType = .latin
        setKeyboardConstraints(.latin)
    }
    
    // MARK: colorChange
    @objc func greyenKey(sender: AnyObject) {
        let key = sender as! UIButton
        key.backgroundColor = UIColor(red: 168/255, green: 176/255, blue: 187/255, alpha: 1)
    }
    
    @objc func whitenKey(sender: AnyObject) {
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
    
    // MARK:- KeySound
    
    @objc func setKeysound(sender: AnyObject) {
        isExtra = false
        
        AudioServicesPlaySystemSound(1104)
    }
    
    @objc func setDeleteKeySound(sender: AnyObject) {
        AudioServicesPlaySystemSound(1155)
    }
    
    @objc func setOtherKeySound(sender: AnyObject) {
        AudioServicesPlaySystemSound(1156)
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
    
    @objc func popupErExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "Ê", "ê")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupIExtra(recog: UILongPressGestureRecognizer) {
        if isShift {
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
    
    @objc func popupNgExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "Ñ", "ñ")
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
        if !isShift {
            if recog.state == .began {
                showPopup(recog: recog, nil, "—")
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupLinearExtra(recog: UILongPressGestureRecognizer) {
        if !isShift {
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
    
    @objc func popupLeftAngleExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "‹", "‹")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupRightAngleExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, "›", "›")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    // MARK:- Methods
    
    func setKeyboardXibs() {
        latinKeyboard = UINib(nibName: "Latin", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        latinKeyboard.frame = view.frame
        latinKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        cyrillicKeyboard = UINib(nibName: "Cyrillic", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        cyrillicKeyboard.frame = view.frame
        cyrillicKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        numMarkKeyboard = UINib(nibName: "NumMark", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        numMarkKeyboard.frame = view.frame
        numMarkKeyboard.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setKeys(_ type: ScriptType, _ isShift: Bool) {
        if type == .latin {
            for key in self.latinKeyboard.subButtons {
                UIView.performWithoutAnimation {
                    switch key.tag {
                    case 1...26: key.setTitle(Const.latinList[isShift]![key.tag-1], for: .normal)
                    case 29:
                        key.setTitle("⇧", for: .normal)
                        key.backgroundColor = isShift ? .white : UIColor(red: 168/255, green: 176/255, blue: 187/255, alpha: 1)
                    default: break
                    }
                    key.layoutIfNeeded()
                }
            }
      } else if type == .cyrillic {
            for key in self.cyrillicKeyboard.subButtons {
                UIView.performWithoutAnimation {
                    switch key.tag {
                    case 1...26: key.setTitle(Const.cyrillicList[isShift]![key.tag-1], for: .normal)
                    case 29:
                        key.setTitle("⇧", for: .normal)
                        key.backgroundColor = isShift ? .white : UIColor(red: 168/255, green: 176/255, blue: 187/255, alpha: 1)
                    default: break
                    }
                    key.layoutIfNeeded()
                }
            }
       } else {
            for key in self.numMarkKeyboard.subButtons {
                UIView.performWithoutAnimation {
                    switch key.tag {
                    case 1...26: key.setTitle(Const.numMarkList[isShift]![key.tag-1], for: .normal)
                    case 29: key.setTitle(isShift ? "123": "#+=", for: .normal)
                    default: break
                    }
                    key.layoutIfNeeded()
                }
            }
        }
    }
    
    func getKey(from type: ScriptType, tag: Int) -> UIButton? {
        if type == .latin {
            for stack in self.latinKeyboard.subviews {
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
        isExtra = true
        
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
        textLabel.text = isShift ? t : f
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
    
    func setKeyboardConstraints(_ type: ScriptType) {
        if constraintH.constant != Const.keyboardHeights[UIScreen.main.bounds.size.height]! {
            constraintH = constraint(self.view, .height, constant: Const.keyboardHeights[UIScreen.main.bounds.size.height]!)
        }
        
        //commonをtypeで切り替える
        for key in constraintsForCommon.keys {
            for const in constraintsForCommon[key]! {
                const.isActive = key == type
            }
        }
        
        if Const.portraitHeights.contains(UIScreen.main.bounds.size.height) {
            //landscape向けを切る
            for const in constraintsForLandscape[type]! {
                const.isActive = false
            }
            
            //portrait向けを有効に
            for key in constraintsForPortrait.keys {
                for const in constraintsForPortrait[key]! {
                    const.isActive = key == type
                }
            }
        } else {
            //portrait向けを切る
            for const in constraintsForPortrait[type]! {
                const.isActive = false
            }
            
            //landscape向けを有効に
            for key in constraintsForLandscape.keys {
                for const in constraintsForLandscape[key]! {
                    const.isActive = key == type
                }
            }
        }
    }
}
