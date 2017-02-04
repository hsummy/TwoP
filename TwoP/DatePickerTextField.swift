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
        picker.addTarget(self, action: #selector(datePickerDateDidChange(picker:)), for: .valueChanged)
    }
    
    @objc private func datePickerDateDidChange(picker: UIDatePicker) {
        text = formatter.string(from: picker.date)
    }
}
