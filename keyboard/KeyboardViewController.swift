//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by 黒岩修 on 1/14/2 R.
//  Copyright © 2 Reiwa 黒岩修. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    weak var keyboardView: UIView!
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーボードの高さ指定
        let constraintH = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 216)
        constraintH.priority = UILayoutPriority(rawValue: 990)
        self.view.addConstraint(constraintH)
        
        //xib設定
        keyboardView = UINib(nibName: "Keyboard", bundle: Bundle.main).instantiate(withOwner: self, options: nil).first as? UIView
        keyboardView.frame = view.frame
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardView)
        
        keyboardView.topAnchor.constraint(equalTo:self.view.topAnchor, constant: 0.0).isActive = true
        keyboardView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor, constant: 0.0).isActive = true
        keyboardView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 0.0).isActive = true
        keyboardView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: 0.0).isActive = true
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
//        var myView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        myView.backgroundColor = UIColor.red
//        self.view.addSubview(myView)
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

}
