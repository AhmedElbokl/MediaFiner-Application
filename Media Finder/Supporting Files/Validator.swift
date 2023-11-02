//
//  Validator.swift
//  Media Finder
//
//  Created by ReMoSTos on 22/05/2023.
//

import Foundation
import UIKit

class Validator {
    private static let sharedInstance = Validator()
    
    static func shared() -> Validator {
       return Validator.sharedInstance
    }
    let format: String = "SELF MATCHES %@"
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format: format, regex)
        return pred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let regex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let pred = NSPredicate(format: format, regex)
        return pred.evaluate(with: password  )
    }
    
    func isValidPhone(_ phone: String?) -> Bool {
        let regex = "^[0-9]{11}$"
        let pred = NSPredicate(format:format, regex)
        return pred.evaluate(with: phone  )
        }
    
}

