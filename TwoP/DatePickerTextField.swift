//
//  DatePickerTextField.swift
//  TwoP
//
//  Created by HSummy on 2/2/17.
//  Copyright © 2017 HSummy. All rights reserved.
//

import UIKit

enum DatePickerTextFieldStyle {
    case time
    case date
}

class DatePickerTextField: UITextField {
    let formatter = DateFormatter()
    let picker = UIDatePicker()
    
    var style: DatePickerTextFieldStyle! {
        didSet { didSet(style) }
    }
    
    func didSet(_ style: DatePickerTextFieldStyle) {
        if style == .time {
            formatter.dateStyle = .none
            picker.datePickerMode = .time
        } else if style == .date {
            formatter.dateStyle = .medium
            picker.datePickerMode = .date
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    func sharedInit() {
        style = .time
        inputView = picker
        picker.backgroundColor = UIColor.white
        picker.addTarget(self, action: #selector(datePickerDateDidChange(_:)), for: .valueChanged)
      
        let width = self.window?.frame.size.width ?? 0
        let frame = CGRect(x: 0, y: 0, width: width, height: 50)
        let button = UIButton(frame: frame)
        button.backgroundColor = UIColor(red:0.38, green:0.62, blue:0.65, alpha:1.00)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneButtonWasTapped(_:)), for: .touchUpInside)
      
        inputAccessoryView = button
    }
    
    @objc private func datePickerDateDidChange(_ picker: UIDatePicker) {
        text = formatter.string(from: picker.date)
    }
  
    @objc private func doneButtonWasTapped(_ sender: UIButton) {
        resignFirstResponder()
    }
}
