//
//  Validator.swift
//  TwoP
//
//  Created by HSummy on 1/26/17.
//  Copyright © 2017 HSummy. All rights reserved.
//

import Foundation


class LoginValidator
{
    func validateEmail(emailString: String) -> Bool
    {
        let coreEmailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", coreEmailRegEx).evaluate(with: emailString)
    }
    //MARK: Password - validate password function http://stackoverflow.com/questions/15132276/password-validation-in-uitextfield-in-ios/40526112#40526112
    func validatePassword(passwordString: String) -> Bool
    {
        //HNS - (Minimum 5 characters at least 1 Alphabet and 1 Number)
        let corePasswordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{5,}$"
        return NSPredicate(format: "SELF MATCHES %@", corePasswordRegEx).evaluate(with: passwordString)
    }

}
