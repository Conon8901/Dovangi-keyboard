//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by 黒岩修 on 1/14/2 R.
//  Copyright © 2 Reiwa 黒岩修. All rights reserved.
//

// TODO: キーの反応範囲
// TODO: 横向きにした時の幅

import UIKit
import AudioToolbox

class KeyboardViewController: UIInputViewController {
    
    // MARK:- 定数変数宣言
    
    var latinKeyboard: UIView!
    var cyrillicKeyboard: UIView!
    var numMarkKeyboard: UIView!
    
    var deleteTimer: Timer!
    
    var constraintH = NSLayoutConstraint()
    
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
    var isExtra = false
    var currentKeyboardType = ScriptType.latin
    
    var chrKeysSpaceNormalColour = UIColor.white
    var spaceTappedColour = UIColor.white
    var otherKeysNormalColour = UIColor.white
    var otherKeysButShiftTappedColour = UIColor.white
    var shiftTappedColour = UIColor.white
    
    // MARK:- 基本設定
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboardXibs()
        
        // For Latin Keyboard
        for key in self.latinKeyboard.subButtons {
            key.setShadow()
            
            switch Const.latinFunctionList[key.tag-1] {
            case .chr:
                key.addTarget(self, action: #selector(latinChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setKeysound), for: .touchDown)
            case .space:
                key.addTarget(self, action: #selector(latinChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(changeSpaceColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreSpaceColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .newline:
                key.addTarget(self, action: #selector(latinChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(changeOtherKeysButShiftColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreOtherKeysButShiftColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .shift: break
            case .delete:
                key.addTarget(self, action: #selector(deleteDown), for: .touchDown)
                key.addTarget(self, action: #selector(deleteUp), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(changeOtherKeysButShiftColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreOtherKeysButShiftColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setDeleteKeySound), for: .touchDown)
            case .changeType:
                key.addTarget(self, action: #selector(latinChangeTypeKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .nextKeyboard:
                key.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                
                key.addTarget(self, action: #selector(changeOtherKeysButShiftColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreOtherKeysButShiftColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            }
        }
        
        // For Cyrillic Keyboard
        for key in self.cyrillicKeyboard.subButtons {
            key.setShadow()
            
            switch Const.cyrillicFunctionList[key.tag-1] {
            case .chr:
                key.addTarget(self, action: #selector(cyrillicChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setKeysound), for: .touchDown)
            case .space:
                key.addTarget(self, action: #selector(cyrillicChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(changeSpaceColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreSpaceColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .newline:
                key.addTarget(self, action: #selector(cyrillicChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(changeOtherKeysButShiftColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreOtherKeysButShiftColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .shift: break
            case .delete:
                key.addTarget(self, action: #selector(deleteDown), for: .touchDown)
                key.addTarget(self, action: #selector(deleteUp), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(changeOtherKeysButShiftColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreOtherKeysButShiftColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setDeleteKeySound), for: .touchDown)
            case .changeType:
                key.addTarget(self, action: #selector(cyrillicChangeTypeKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .nextKeyboard:
                key.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                
                key.addTarget(self, action: #selector(changeOtherKeysButShiftColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreOtherKeysButShiftColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            }
        }
        
        // For NumMark Keyboard
        for key in self.numMarkKeyboard.subButtons {
            key.setShadow()
            
            switch Const.numMarkFunctionList[key.tag-1] {
            case .chr:
                key.addTarget(self, action: #selector(numMarkChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setKeysound), for: .touchDown)
            case .space:
                key.addTarget(self, action: #selector(numMarkChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(changeSpaceColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreSpaceColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .newline:
                key.addTarget(self, action: #selector(numMarkChrKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(changeOtherKeysButShiftColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreOtherKeysButShiftColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .shift:
                key.addTarget(self, action: #selector(numMarkShiftKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .delete:
                key.addTarget(self, action: #selector(deleteDown), for: .touchDown)
                key.addTarget(self, action: #selector(deleteUp), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(changeOtherKeysButShiftColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreOtherKeysButShiftColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setDeleteKeySound), for: .touchDown)
            case .changeType:
                key.addTarget(self, action: #selector(numMarkChangeTypeKeyPressed), for: .touchUpInside)
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            case .nextKeyboard:
                key.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                
                key.addTarget(self, action: #selector(changeOtherKeysButShiftColour), for: .touchDown)
                key.addTarget(self, action: #selector(restoreOtherKeysButShiftColour), for: [.touchUpInside, .touchUpOutside])
                
                key.addTarget(self, action: #selector(setOtherKeySound), for: .touchDown)
            }
        }
        
        // 制約設定
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
        
        // MARK:NRT: Extras
        addLongPressGesture(#selector(popupNgExtra), to: getKey(from: .latin, tag: 8)!)
        addLongPressGesture(#selector(popupAwExtra), to: getKey(from: .latin, tag: 25)!)
        
        addLongPressGesture(#selector(popupDashExtra), to: getKey(from: .numMark, tag: 13)!)
        addLongPressGesture(#selector(popupSlashExtra), to: getKey(from: .numMark, tag: 14)!)
        addLongPressGesture(#selector(popupColonExtra), to: getKey(from: .numMark, tag: 15)!)
        addLongPressGesture(#selector(popupBulletExtra), to: getKey(from: .numMark, tag: 20)!)
        addLongPressGesture(#selector(popupPeriodExtra), to: getKey(from: .numMark, tag: 21)!)
        addLongPressGesture(#selector(popupLeftAngleExtra), to: getKey(from: .numMark, tag: 25)!)
        addLongPressGesture(#selector(popupRightAngleExtra), to: getKey(from: .numMark, tag: 26)!)
    }
    
    //iPhone XなどでinputModeSwitchKeyを削除
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if !self.needsInputModeSwitchKey {
            for type in [ScriptType.latin, ScriptType.cyrillic, ScriptType.numMark] {
                getKey(from: type, tag: Const.KeyCounts[type]!)?.removeFromSuperview()
                // inputModeSwitchKeyはtag順最後のボタンなので、ボタンの個数と一致する
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) { // sizeはself.viewのsize
        setKeyboardConstraints(currentKeyboardType)
    }
    
    //ライト／ダークモード切り替え
    override func textDidChange(_ textInput: UITextInput?) {
        if self.textDocumentProxy.keyboardAppearance == .light {
            chrKeysSpaceNormalColour = Const.chrKeysColourLight
            spaceTappedColour = Const.otherKeysColourLight
            otherKeysNormalColour = Const.otherKeysColourLight
            otherKeysButShiftTappedColour = Const.chrKeysColourLight
            shiftTappedColour = Const.chrKeysColourLight
        } else {
            chrKeysSpaceNormalColour = Const.otherKeysColourDark
            spaceTappedColour = Const.chrKeysColourDark
            otherKeysNormalColour = Const.chrKeysColourDark
            otherKeysButShiftTappedColour = Const.otherKeysColourDark
            shiftTappedColour = Const.tappedShiftColourDark
        }
        
        var chrTextColour: UIColor
        var otrTextColour: UIColor
        var shadowColour: CGColor
        var bgColour: UIColor
        
        if self.textDocumentProxy.keyboardAppearance == .light {
            chrTextColour = .black
            otrTextColour = .black
            shadowColour = Const.shadowColourLight.cgColor
            bgColour = Const.keyboardBgColourLight
        } else {
            chrTextColour = .white
            otrTextColour = .white
            shadowColour = Const.shadowColourDark.cgColor
            bgColour = Const.keyboardBgColourDark
        }
        
        for type in [ScriptType.latin, ScriptType.cyrillic, ScriptType.numMark] {
            let keyCount = Const.KeyCounts[type]!
            let spaceKey = (type == .numMark) ? (keyCount - 5) : (keyCount - 4)
            
            for i in 1...keyCount {
                if i <= spaceKey {
                    getKey(from: type, tag: i)!.setTitleColor(chrTextColour, for: [])
                    getKey(from: type, tag: i)!.backgroundColor = chrKeysSpaceNormalColour
                } else {
                    getKey(from: type, tag: i)!.setTitleColor(otrTextColour, for: [])
                    getKey(from: type, tag: i)!.backgroundColor = otherKeysNormalColour
                }
                
                getKey(from: type, tag: i)!.layer.shadowOffset = CGSize(width: 0.0, height: 1.2)
                getKey(from: type, tag: i)!.layer.shadowColor = shadowColour
                getKey(from: type, tag: i)!.layer.shadowOpacity = 0.8
                getKey(from: type, tag: i)!.layer.shadowRadius = 0
            }
        }
        
        latinKeyboard.backgroundColor = bgColour
        cyrillicKeyboard.backgroundColor = bgColour
        numMarkKeyboard.backgroundColor = bgColour
    }
    
    // MARK:- ボタン押下時の処理
    @objc func latinChrKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        
        var str = ""
        
        if isExtra {
            str = Const.latinExtraList[key.tag]!
        } else {
            str = Const.latinList[key.tag-1]
        }
        
        self.textDocumentProxy.insertText(str)
    }
    
    @objc func latinChangeTypeKeyPressed(sender: AnyObject) {
        latinKeyboard.removeFromSuperview()
        
        view.addSubview(cyrillicKeyboard)
        
        currentKeyboardType = .cyrillic
        setKeyboardConstraints(.cyrillic)
    }
    
    @objc func cyrillicChrKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        
        var str = ""
        
        str = Const.cyrillicList[key.tag-1]
        
        self.textDocumentProxy.insertText(str)
    }
    
    @objc func cyrillicChangeTypeKeyPressed(sender: AnyObject) {
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
    
    // MARK: ボタン押下時の背景色操作
    
    @objc func changeSpaceColour(sender: AnyObject) {
        let key = sender as! UIButton
        key.backgroundColor = spaceTappedColour
    }
    
    @objc func restoreSpaceColour(sender: AnyObject) {
        let key = sender as! UIButton
        key.backgroundColor = chrKeysSpaceNormalColour
    }
    
    @objc func changeOtherKeysButShiftColour(sender: AnyObject) {
        let key = sender as! UIButton
        key.backgroundColor = otherKeysButShiftTappedColour
    }
    
    @objc func restoreOtherKeysButShiftColour(sender: AnyObject) {
        let key = sender as! UIButton
        key.backgroundColor = otherKeysNormalColour
    }
    
    //MARK: 削除キー設定
    
    @objc func deleteDown(sender: AnyObject) {
        if self.textDocumentProxy.hasText {
            self.textDocumentProxy.deleteBackward()
        }
        
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
        if deleteTimer.isValid {
            deleteTimer.invalidate()
        }
    }
    
    // MARK:- 押下音設定
    
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
    
    // MARK:- NRT: Extraそれぞれの設定
    // MARK: latin
    
    @objc func popupNgExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, f: "ń")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupAwExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, f: "ą")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    // MARK: numMark
    
    @objc func popupDashExtra(recog: UILongPressGestureRecognizer) {
        if !isShift {
            if recog.state == .began {
                showPopup(recog: recog, f: "—")
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview() //[0]は元ボタンの文字部分
            }
        }
    }
    
    @objc func popupSlashExtra(recog: UILongPressGestureRecognizer) {
        if !isShift {
            if recog.state == .began {
                showPopup(recog: recog, f: "\\")
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupColonExtra(recog: UILongPressGestureRecognizer) {
        if !isShift {
            if recog.state == .began {
                showPopup(recog: recog, f: ";")
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupBulletExtra(recog: UILongPressGestureRecognizer) {
        if !isShift {
            if recog.state == .began {
                showPopup(recog: recog, f: "◦")
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupPeriodExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, t: "…", f: "…")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupLeftAngleExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, t: "‹", f: "‹")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupRightAngleExtra(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            showPopup(recog: recog, t: "›", f: "›")
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    // MARK:- 諸々のメソッド
    
    func setKeyboardXibs() {
        latinKeyboard = UINib(nibName: "Latin", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        latinKeyboard.frame = view.frame
        latinKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        cyrillicKeyboard = UINib(nibName: "Cyrillic", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        cyrillicKeyboard.frame = view.frame
        cyrillicKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        numMarkKeyboard = UINib(nibName: "NumMark", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        numMarkKeyboard.frame = view.frame
        numMarkKeyboard.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setKeys(_ type: ScriptType, _ isShift: Bool) {
        if type == .latin {
            for key in self.latinKeyboard.subButtons {
                UIView.performWithoutAnimation {
                    switch key.tag {
                    case 1...(Const.KeyCounts[.latin]! - 5): key.setTitle(Const.latinList[key.tag-1], for: .normal)
                    default: break
                    }
                    key.layoutIfNeeded()
                }
            }
        } else if type == .cyrillic {
            for key in self.cyrillicKeyboard.subButtons {
                UIView.performWithoutAnimation {
                    switch key.tag {
                    case 1...(Const.KeyCounts[.cyrillic]! - 5): key.setTitle(Const.cyrillicList[key.tag-1], for: .normal)
                    default: break
                    }
                    key.layoutIfNeeded()
                }
            }
        } else {
            for key in self.numMarkKeyboard.subButtons {
                UIView.performWithoutAnimation {
                    switch key.tag {
                    case 1...(Const.KeyCounts[.numMark]! - 6): key.setTitle(Const.numMarkList[isShift]![key.tag-1], for: .normal)
                    case (Const.KeyCounts[.numMark]! - 3): key.setTitle(isShift ? "123": "#+=", for: .normal)
                    default: break
                    }
                    key.layoutIfNeeded()
                }
            }
        }
    }
    
    func getKey(from type: ScriptType, tag: Int) -> UIButton? {
        let keyboards: [ScriptType:UIView] = [.latin: self.latinKeyboard, .cyrillic: self.cyrillicKeyboard, .numMark: self.numMarkKeyboard]
        
        for stack in keyboards[type]!.subviews {
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
        
        return nil
    }
    
    func showPopup(recog: UIGestureRecognizer, t: String? = nil, f: String? = nil) {
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
