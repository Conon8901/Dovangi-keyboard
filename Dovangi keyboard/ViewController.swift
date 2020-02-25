//
//  ViewController.swift
//  Dovangi keyboard
//
//  Created by 黒岩修 on 1/14/2 R.
//  Copyright © 2 Reiwa 黒岩修. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var txtV: UITextView!
    @IBOutlet var dammyV: UITextView!
    
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txtV.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        button.isEnabled = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        dammyV.isHidden = textView.hasText
    }
    
    @IBAction func closeKeyboard() {
        txtV.endEditing(true)
        
        button.isEnabled = false
    }
}

