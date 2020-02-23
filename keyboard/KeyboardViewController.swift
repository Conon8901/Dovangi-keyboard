//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by 黒岩修 on 1/14/2 R.
//  Copyright © 2 Reiwa 黒岩修. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    enum scriptType {
        case latin
        case cyrillic
    }
    
    struct Const {
        static var isShift = false
//        static var isShiftSucceeding = false
        static var isExtra = false
    }
    
    weak var keyboardView: UIView!
    
    var latinKeyboard: UIView!
    var cyrillicKeyboard: UIView!
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーボードの高さ指定
        let constraintH = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 226)
        constraintH.priority = UILayoutPriority(rawValue: 990)
        self.view.addConstraint(constraintH)
        
        //xib設定
        latinKeyboard = UINib(nibName: "Latin", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        latinKeyboard.frame = view.frame
        latinKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        keyboardView = latinKeyboard
        view.addSubview(keyboardView)
        
        keyboardView.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 0.0).isActive = true
        keyboardView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor, constant: 0.0).isActive = true
        keyboardView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 0.0).isActive = true
        keyboardView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: 0.0).isActive = true
        
        //addTarget と 影
        for stack in self.latinKeyboard.subviews {
            if stack is UIStackView {
                for keytobe in stack.subviews {
                    let key = keytobe as! UIButton
                    
                    key.layer.shadowOffset = CGSize(width: 0.0, height: 1.2)
                    key.layer.shadowColor = UIColor.gray.cgColor
                    key.layer.shadowOpacity = 0.8
                    key.layer.shadowRadius = 0
                    
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
                    } else {
                        key.addTarget(self, action: #selector(keyTouchedDown), for: .touchDown)
                        key.addTarget(self, action: #selector(lKeyPressed), for: .touchUpInside)
                    }
                }
            }
        }
        
        cyrillicKeyboard = UINib(nibName: "Cyrillic", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        cyrillicKeyboard.frame = view.frame
        cyrillicKeyboard.translatesAutoresizingMaskIntoConstraints = false
        
        //addTarget と 影
        for stack in self.cyrillicKeyboard.subviews {
            if stack is UIStackView {
                for keytobe in stack.subviews {
                    if let key = keytobe as? UIButton {
                        key.layer.shadowOffset = CGSize(width: 0.0, height: 1.2)
                        key.layer.shadowColor = UIColor.gray.cgColor
                        key.layer.shadowOpacity = 0.8
                        key.layer.shadowRadius = 0
                        
                        if key.tag == 30 { // deleteKey
                            key.addTarget(self, action: #selector(deleteChr), for: .touchDown)
                        } else {
                            key.addTarget(self, action: #selector(keyTouchedDown), for: .touchDown)
                            key.addTarget(self, action: #selector(cKeyPressed), for: .touchUpInside)
                        }
                    } else {
                        for keys in keytobe.subviews {
                            let key = keys as! UIButton
                            
                            key.layer.shadowOffset = CGSize(width: 0.0, height: 1.2)
                            key.layer.shadowColor = UIColor.gray.cgColor
                            key.layer.shadowOpacity = 0.8
                            key.layer.shadowRadius = 0
                            
                            key.addTarget(self, action: #selector(keyTouchedDown), for: .touchDown)
                            key.addTarget(self, action: #selector(cKeyPressed), for: .touchUpInside)
                        }
                    }
                }
            }
        }
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        // 代用表記表示
        let qRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupQExtras))
        qRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 1)!.addGestureRecognizer(qRecog)
        
        let ngqRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupNgqExtras))
        ngqRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 2)!.addGestureRecognizer(ngqRecog)
        
        let erRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupErExtras))
        erRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 4)!.addGestureRecognizer(erRecog)
        
        let iRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupIExtras))
        iRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 8)!.addGestureRecognizer(iRecog)
        
        let orRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupOrExtras))
        orRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 10)!.addGestureRecognizer(orRecog)
        
        let ndRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupNdExtras))
        ndRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 15)!.addGestureRecognizer(ndRecog)
        
        let nggRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupNggExtras))
        nggRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 18)!.addGestureRecognizer(nggRecog)
        
        let ngRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupNgExtras))
        ngRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 19)!.addGestureRecognizer(ngRecog)
        
        let nzRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupNzExtras))
        nzRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 23)!.addGestureRecognizer(nzRecog)
        
        let mvRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupMvExtras))
        mvRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 26)!.addGestureRecognizer(mvRecog)
        
        let mbRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.popupMbExtras))
        mbRecog.cancelsTouchesInView = false
        getButton(.latin, tag: 28)!.addGestureRecognizer(mbRecog)
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
    
    @objc func keyTouchedDown(sender: AnyObject) {
        Const.isExtra = false
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
    
    @objc func lKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        if key.tag<=33 { // insertText
            var string = ""
            if Const.isShift {
                switch key.tag {
                case 1: string = Const.isExtra ? "Q" : "Ƣ"
                case 2: string = Const.isExtra ? "Q̆" : "Ɋ"
                case 3: string = "E"
                case 4: string = Const.isExtra ? "Ê" : "Ɛ"
                case 5: string = "T"
                case 6: string = "Ł"
                case 7: string = "U"
                case 8: string = Const.isExtra ? "Y" : "İ"
                case 9: string = "O"
                case 10: string = Const.isExtra ? "Ô" : "Ɔ"
                case 11: string = "P"
                case 12: string = "A"
                case 13: string = "S"
                case 14: string = "D"
                case 15: string = Const.isExtra ? "D̆" : "Ɗ"
                case 16: string = "F"
                case 17: string = "G"
                case 18: string = Const.isExtra ? "Ğ" : "Ɠ"
                case 19: string = Const.isExtra ? "Ñ" : "Ŋ"
                case 20: string = "K"
                case 21: string = "L"
                case 22: string = "R"
                case 23: string = "Z"
                case 24: string = Const.isExtra ? "Z̆" : "Ȥ"
                case 25: string = "X"
                case 26: string = "V"
                case 27: string = Const.isExtra ? "V̆" : "Ʋ"
                case 28: string = "B"
                case 29: string = Const.isExtra ? "B̆" : "Ɓ"
                case 30: string = "N"
                case 31: string = "M"
                case 32: string = " "
                case 33: string = "\n"
                default: break
                }
                
                Const.isShift = false
                setKeys(.latin, false)
                
//                if !Const.isShiftSucceeding {
//                    Const.isShift = false
//
//                    setKeys(false)
//                }
                
            } else {
                switch key.tag {
                case 1: string = Const.isExtra ? "q" : "ƣ"
                case 2: string = Const.isExtra ? "q̆" : "ɋ"
                case 3: string = "e"
                case 4: string = Const.isExtra ? "ê" : "ɛ"
                case 5: string = "t"
                case 6: string = "ł"
                case 7: string = "u"
                case 8: string = "i"
                case 9: string = "o"
                case 10: string = Const.isExtra ? "ô" : "ɔ"
                case 11: string = "p"
                case 12: string = "a"
                case 13: string = "s"
                case 14: string = "d"
                case 15: string = Const.isExtra ? "d̆" : "ɗ"
                case 16: string = "f"
                case 17: string = "g"
                case 18: string = Const.isExtra ? "ğ" : "ɠ"
                case 19: string = Const.isExtra ? "ñ" : "ŋ"
                case 20: string = "k"
                case 21: string = "l"
                case 22: string = "r"
                case 23: string = "z"
                case 24: string = Const.isExtra ? "z̆" : "ȥ"
                case 25: string = "x"
                case 26: string = "v"
                case 27: string = Const.isExtra ? "v̆" : "ʋ"
                case 28: string = "b"
                case 29: string = Const.isExtra ? "b̆" : "ɓ"
                case 30: string = "n"
                case 31: string = "m"
                case 32: string = " "
                case 33: string = "\n"
                default: break
                }
            }
            
            self.textDocumentProxy.insertText(string)
        }
        
        if key.tag == 34 {
            Const.isShift = !Const.isShift
            setKeys(.latin, Const.isShift)
        }
        
        if key.tag == 36 {
            Const.isShift = false
            
            keyboardView.removeFromSuperview()
            
            keyboardView = cyrillicKeyboard
            view.addSubview(keyboardView)
            
            print("l > c", Const.isShift, getButton(.latin, tag: 1)!.titleLabel!.text!, ">", getButton(.cyrillic, tag: 1)!.titleLabel!.text!)
            
            keyboardView.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 0.0).isActive = true
            keyboardView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor, constant: 0.0).isActive = true
            keyboardView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 0.0).isActive = true
            keyboardView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: 0.0).isActive = true
        }
    }
    
    @objc func cKeyPressed(sender: AnyObject) {
        let key = sender as! UIButton
        if key.tag<=28 { // insertText
            var string = ""
            if Const.isShift {
                switch key.tag {
                case 1: string = "У"
                case 2: string = "К"
                case 3: string = "Е"
                case 4: string = "Н"
                case 5: string = "Г"
                case 6: string = "З"
                case 7: string = "Х"
                case 8: string = "Ъ"
                case 9: string = "Ң"
                case 10: string = "Ғ"
                case 11: string = "Ф"
                case 12: string = "В"
                case 13: string = "А"
                case 14: string = "П"
                case 15: string = "О"
                case 16: string = "Л"
                case 17: string = "Д"
                case 18: string = "Э"
                case 19: string = "Ԓ"
                case 20: string = "С"
                case 21: string = "М"
                case 22: string = "И"
                case 23: string = "Т"
                case 24: string = "Б"
                case 25: string = "Ә"
                case 26: string = String(UnicodeScalar(774)!)
                case 27: string = " "
                case 28: string = "\n"
                default: break
                }
                
                Const.isShift = false
                setKeys(.cyrillic, false)
                
            } else {
                switch key.tag {
                case 1: string = "у"
                case 2: string = "к"
                case 3: string = "е"
                case 4: string = "н"
                case 5: string = "г"
                case 6: string = "з"
                case 7: string = "х"
                case 8: string = "ъ"
                case 9: string = "ң"
                case 10: string = "ғ"
                case 11: string = "ф"
                case 12: string = "в"
                case 13: string = "а"
                case 14: string = "п"
                case 15: string = "о"
                case 16: string = "л"
                case 17: string = "д"
                case 18: string = "э"
                case 19: string = "ԓ"
                case 20: string = "с"
                case 21: string = "м"
                case 22: string = "и"
                case 23: string = "т"
                case 24: string = "б"
                case 25: string = "ә"
                case 26: string = String(UnicodeScalar(774)!)
                case 27: string = " "
                case 28: string = "\n"
                default: break
                }
            }
            
            self.textDocumentProxy.insertText(string)
        }
        
        if key.tag == 29 {
            Const.isShift = !Const.isShift
            setKeys(.cyrillic, Const.isShift)
        }
        
        if key.tag == 31 {
            Const.isShift = false
            
            keyboardView.removeFromSuperview()
            
            keyboardView = latinKeyboard
            view.addSubview(keyboardView)
            
            print("c > l", Const.isShift, getButton(.cyrillic, tag: 1)!.titleLabel!.text!, ">", getButton(.latin, tag: 1)!.titleLabel!.text!)

            keyboardView.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 0.0).isActive = true
            keyboardView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor, constant: 0.0).isActive = true
            keyboardView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 0.0).isActive = true
            keyboardView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: 0.0).isActive = true
        }
    }
    
    @objc func deleteChr() {
        self.textDocumentProxy.deleteBackward()
    }
    
    func setKeys(_ type: scriptType, _ isShift: Bool) {
        if type == .latin {
            if isShift {
                for stack in self.keyboardView.subviews {
                    for keytobe in stack.subviews  {
                        let key = keytobe as! UIButton
                        UIView.performWithoutAnimation {
                            switch key.tag {
                            case 1: key.setTitle("Ƣ", for: .normal)
                            case 2: key.setTitle("Ɋ", for: .normal)
                            case 3: key.setTitle("E", for: .normal)
                            case 4: key.setTitle("Ɛ", for: .normal)
                            case 5: key.setTitle("T", for: .normal)
                            case 6: key.setTitle("Ł", for: .normal)
                            case 7: key.setTitle("U", for: .normal)
                            case 8: key.setTitle("İ", for: .normal)
                            case 9: key.setTitle("O", for: .normal)
                            case 10: key.setTitle("Ɔ", for: .normal)
                            case 11: key.setTitle("P", for: .normal)
                            case 12: key.setTitle("A", for: .normal)
                            case 13: key.setTitle("S", for: .normal)
                            case 14: key.setTitle("D", for: .normal)
                            case 15: key.setTitle("Ɗ", for: .normal)
                            case 16: key.setTitle("F", for: .normal)
                            case 17: key.setTitle("G", for: .normal)
                            case 18: key.setTitle("Ɠ", for: .normal)
                            case 19: key.setTitle("Ŋ", for: .normal)
                            case 20: key.setTitle("K", for: .normal)
                            case 21: key.setTitle("L", for: .normal)
                            case 22: key.setTitle("R", for: .normal)
                            case 23: key.setTitle("Z", for: .normal)
                            case 24: key.setTitle("Ȥ", for: .normal)
                            case 25: key.setTitle("X", for: .normal)
                            case 26: key.setTitle("V", for: .normal)
                            case 27: key.setTitle("Ʋ", for: .normal)
                            case 28: key.setTitle("B", for: .normal)
                            case 29: key.setTitle("Ɓ", for: .normal)
                            case 30: key.setTitle("N", for: .normal)
                            case 31: key.setTitle("M", for: .normal)
                            case 34: key.setTitle("⇪", for: .normal)
                            default: break
                            }
                            key.layoutIfNeeded()
                        }
                    }
                }
            } else {
                for stack in self.keyboardView.subviews {
                    for keytobe in stack.subviews {
                        let key = keytobe as! UIButton
                        
                        UIView.performWithoutAnimation {
                            switch key.tag {
                            case 1: key.setTitle("ƣ", for: .normal)
                            case 2: key.setTitle("ɋ", for: .normal)
                            case 3: key.setTitle("e", for: .normal)
                            case 4: key.setTitle("ɛ", for: .normal)
                            case 5: key.setTitle("t", for: .normal)
                            case 6: key.setTitle("ł", for: .normal)
                            case 7: key.setTitle("u", for: .normal)
                            case 8: key.setTitle("i", for: .normal)
                            case 9: key.setTitle("o", for: .normal)
                            case 10: key.setTitle("ɔ", for: .normal)
                            case 11: key.setTitle("p", for: .normal)
                            case 12: key.setTitle("a", for: .normal)
                            case 13: key.setTitle("s", for: .normal)
                            case 14: key.setTitle("d", for: .normal)
                            case 15: key.setTitle("ɗ", for: .normal)
                            case 16: key.setTitle("f", for: .normal)
                            case 17: key.setTitle("g", for: .normal)
                            case 18: key.setTitle("ɠ", for: .normal)
                            case 19: key.setTitle("ŋ", for: .normal)
                            case 20: key.setTitle("k", for: .normal)
                            case 21: key.setTitle("l", for: .normal)
                            case 22: key.setTitle("r", for: .normal)
                            case 23: key.setTitle("z", for: .normal)
                            case 24: key.setTitle("ȥ", for: .normal)
                            case 25: key.setTitle("x", for: .normal)
                            case 26: key.setTitle("v", for: .normal)
                            case 27: key.setTitle("ʋ", for: .normal)
                            case 28: key.setTitle("b", for: .normal)
                            case 29: key.setTitle("ɓ", for: .normal)
                            case 30: key.setTitle("n", for: .normal)
                            case 31: key.setTitle("m", for: .normal)
                            case 34: key.setTitle("⇧", for: .normal)
                            default: break
                            }
                            key.layoutIfNeeded()
                        }
                    }
                }
            }
        } else {
            if isShift {
                for stack in self.keyboardView.subviews {
                    for keytobe in stack.subviews  {
                        if let key = keytobe as? UIButton {
                            UIView.performWithoutAnimation {
                                switch key.tag {
                                case 1: key.setTitle("У", for: .normal)
                                case 2: key.setTitle("К", for: .normal)
                                case 3: key.setTitle("Е", for: .normal)
                                case 4: key.setTitle("Н", for: .normal)
                                case 5: key.setTitle("Г", for: .normal)
                                case 6: key.setTitle("З", for: .normal)
                                case 7: key.setTitle("Х", for: .normal)
                                case 8: key.setTitle("Ъ", for: .normal)
                                case 9: key.setTitle("Ң", for: .normal)
                                case 10: key.setTitle("Ғ", for: .normal)
                                case 11: key.setTitle("Ф", for: .normal)
                                case 12: key.setTitle("В", for: .normal)
                                case 13: key.setTitle("А", for: .normal)
                                case 14: key.setTitle("П", for: .normal)
                                case 15: key.setTitle("О", for: .normal)
                                case 16: key.setTitle("Л", for: .normal)
                                case 17: key.setTitle("Д", for: .normal)
                                case 18: key.setTitle("Э", for: .normal)
                                case 19: key.setTitle("Ԓ", for: .normal)
                                case 29: key.setTitle("⇪", for: .normal)
                                default: break
                                }
                                key.layoutIfNeeded()
                            }
                        } else {
                            for keys in keytobe.subviews {
                                let key = keys as! UIButton
                                
                                UIView.performWithoutAnimation {
                                    switch key.tag {
                                    case 20: key.setTitle("С", for: .normal)
                                    case 21: key.setTitle("М", for: .normal)
                                    case 22: key.setTitle("И", for: .normal)
                                    case 23: key.setTitle("Т", for: .normal)
                                    case 24: key.setTitle("Б", for: .normal)
                                    case 25: key.setTitle("Ә", for: .normal)
                                    case 26: key.setTitle("◌̆", for: .normal)
                                    default: break
                                    }
                                    key.layoutIfNeeded()
                                }
                            }
                        }
                    }
                }
            } else {
                for stack in self.keyboardView.subviews {
                    for keytobe in stack.subviews {
                        if let key = keytobe as? UIButton {
                            UIView.performWithoutAnimation {
                                switch key.tag {
                                case 1: key.setTitle("у", for: .normal)
                                case 2: key.setTitle("к", for: .normal)
                                case 3: key.setTitle("е", for: .normal)
                                case 4: key.setTitle("н", for: .normal)
                                case 5: key.setTitle("г", for: .normal)
                                case 6: key.setTitle("з", for: .normal)
                                case 7: key.setTitle("х", for: .normal)
                                case 8: key.setTitle("ъ", for: .normal)
                                case 9: key.setTitle("ң", for: .normal)
                                case 10: key.setTitle("ғ", for: .normal)
                                case 11: key.setTitle("ф", for: .normal)
                                case 12: key.setTitle("в", for: .normal)
                                case 13: key.setTitle("а", for: .normal)
                                case 14: key.setTitle("п", for: .normal)
                                case 15: key.setTitle("о", for: .normal)
                                case 16: key.setTitle("л", for: .normal)
                                case 17: key.setTitle("д", for: .normal)
                                case 18: key.setTitle("э", for: .normal)
                                case 19: key.setTitle("ԓ", for: .normal)
                                case 29: key.setTitle("⇧", for: .normal)
                                default: break
                                }
                                key.layoutIfNeeded()
                            }
                        } else {
                            for keys in keytobe.subviews {
                                let key = keys as! UIButton
                                
                                UIView.performWithoutAnimation {
                                    switch key.tag {
                                    case 20: key.setTitle("с", for: .normal)
                                    case 21: key.setTitle("м", for: .normal)
                                    case 22: key.setTitle("и", for: .normal)
                                    case 23: key.setTitle("т", for: .normal)
                                    case 24: key.setTitle("б", for: .normal)
                                    case 25: key.setTitle("Ә", for: .normal)
                                    case 26: key.setTitle("◌̆", for: .normal)
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
    }
    
    func getButton(_ type: scriptType, tag: Int) -> UIButton? {
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
        } else {
            for stack in self.cyrillicKeyboard.subviews {
                for keytobe in stack.subviews {
                    if keytobe.tag == tag {
                        let key = keytobe as! UIButton
                        return key
                    } else {
                        continue
                    }
                }
            }
        }
        
        return nil
    }
    
    @objc func popupQExtras(recog: UILongPressGestureRecognizer) { // 被せている
        if recog.state == .began {
            Const.isExtra = true
            
            let button = recog.view as! UIButton
            
            var popupFrame: CGRect
            var textLabelFrame: CGRect
            
            popupFrame = CGRect(x: 0 , y: 0, width: button.frame.size.width, height: button.frame.size.height)
            textLabelFrame = CGRect(x: 3, y: 3, width: popupFrame.size.width-6, height: popupFrame.size.height-6)
            
            let popup = UIView(frame: popupFrame)
            popup.backgroundColor = .black
            popup.layer.cornerRadius = 5
            
//            button.superview?.frame
            
            let textLabel = UILabel()
            textLabel.frame = textLabelFrame
            textLabel.text = Const.isShift ? "Q" : "q"
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 23)
            textLabel.textColor = .white
            
            popup.addSubview(textLabel)
            
            button.addSubview(popup)
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNgqExtras(recog: UILongPressGestureRecognizer) { // 被せている
        if recog.state == .began {
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
            textLabel.text = Const.isShift ? "Q̆" : "q̆"
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 23)
            textLabel.textColor = .white
            
            popup.addSubview(textLabel)
            
            button.addSubview(popup)
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupErExtras(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
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
            textLabel.text = Const.isShift ? "Ê" : "ê"
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 23)
            textLabel.textColor = .white
            
            popup.addSubview(textLabel)
            
            button.addSubview(popup)
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupIExtras(recog: UILongPressGestureRecognizer) {
        if Const.isShift {
            if recog.state == .began {
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
                textLabel.text = "Y"
                textLabel.textAlignment = .center
                textLabel.font = UIFont.systemFont(ofSize: 23)
                textLabel.textColor = .white
                
                popup.addSubview(textLabel)
                
                button.addSubview(popup)
            } else if recog.state == .ended {
                let button = recog.view as! UIButton
                button.subviews[1].removeFromSuperview()
            }
        }
    }
    
    @objc func popupOrExtras(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
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
            textLabel.text = Const.isShift ? "Ô" : "ô"
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 23)
            textLabel.textColor = .white
            
            popup.addSubview(textLabel)
            
            button.addSubview(popup)
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNdExtras(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
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
            textLabel.text = Const.isShift ? "D̆" : "d̆"
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 23)
            textLabel.textColor = .white
            
            popup.addSubview(textLabel)
            
            button.addSubview(popup)
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNggExtras(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
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
            textLabel.text = Const.isShift ? "Ğ" : "ğ"
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 23)
            textLabel.textColor = .white
            
            popup.addSubview(textLabel)
            
            button.addSubview(popup)
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNgExtras(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            Const.isExtra = true
            
            let button = recog.view as! UIButton
            
            var popupFrame: CGRect
            var textLabelFrame: CGRect
            
//            print(button.frame.origin.y, button.superview?.frame.origin.y, button.frame.size.height, button.superview)
//            popupFrame = CGRect(x: button.frame.origin.x-3 , y: button.superview!.frame.origin.y-button.frame.size.height-6, width: button.frame.size.width+6, height: button.frame.size.height+6)
//            textLabelFrame = CGRect(x: popupFrame.origin.x+3, y: popupFrame.origin.y+3, width: popupFrame.size.width-6, height: popupFrame.size.height-6)
            
            popupFrame = CGRect(x: 0 , y: 0, width: button.frame.size.width, height: button.frame.size.height)
            textLabelFrame = CGRect(x: 3, y: 3, width: popupFrame.size.width-6, height: popupFrame.size.height-6)
            
            let popup = UIView(frame: popupFrame)
            popup.backgroundColor = .black
            popup.layer.cornerRadius = 5
            
            let textLabel = UILabel()
            textLabel.frame = textLabelFrame
            textLabel.text = Const.isShift ? "Ñ" : "ñ"
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 23)
            textLabel.textColor = .white
            
            popup.addSubview(textLabel)
            
            button.addSubview(popup)
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupNzExtras(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
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
            textLabel.text = Const.isShift ? "Z̆" : "z̆"
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 23)
            textLabel.textColor = .white
            
            popup.addSubview(textLabel)
            
            button.addSubview(popup)
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupMvExtras(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
            Const.isExtra = true
            
            let button = recog.view as! UIButton
            
            var popupFrame: CGRect
            var textLabelFrame: CGRect
            
            //            print(button.frame.origin.y, button.superview?.frame.origin.y, button.frame.size.height, button.superview)
            //            popupFrame = CGRect(x: button.frame.origin.x-3 , y: button.superview!.frame.origin.y-button.frame.size.height-6, width: button.frame.size.width+6, height: button.frame.size.height+6)
            //            textLabelFrame = CGRect(x: popupFrame.origin.x+3, y: popupFrame.origin.y+3, width: popupFrame.size.width-6, height: popupFrame.size.height-6)
            
            popupFrame = CGRect(x: 0 , y: 0, width: button.frame.size.width, height: button.frame.size.height)
            textLabelFrame = CGRect(x: 3, y: 3, width: popupFrame.size.width-6, height: popupFrame.size.height-6)
            
            let popup = UIView(frame: popupFrame)
            popup.backgroundColor = .black
            popup.layer.cornerRadius = 5
            
            let textLabel = UILabel()
            textLabel.frame = textLabelFrame
            textLabel.text = Const.isShift ? "V̆" : "v̆"
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 23)
            textLabel.textColor = .white
            
            popup.addSubview(textLabel)
            
            button.addSubview(popup)
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
    
    @objc func popupMbExtras(recog: UILongPressGestureRecognizer) {
        if recog.state == .began {
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
            textLabel.text = Const.isShift ? "B̆" : "b̆"
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 23)
            textLabel.textColor = .white
            
            popup.addSubview(textLabel)
            
            button.addSubview(popup)
        } else if recog.state == .ended {
            let button = recog.view as! UIButton
            button.subviews[1].removeFromSuperview()
        }
    }
}
