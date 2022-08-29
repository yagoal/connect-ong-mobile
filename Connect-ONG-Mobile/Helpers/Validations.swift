//
//  Validations.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 28/8/22.
//

import Foundation

func isValidEmailAddr(strToValidate: String) -> Bool {
    let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"  // 1

    let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)  // 2

    return emailValidationPredicate.evaluate(with: strToValidate)  // 3
}
