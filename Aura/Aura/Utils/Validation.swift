//
//  Validation.swift
//  Aura
//
//  Created by Julien Choromanski on 29/03/2025.
//

import Foundation

struct ValidationUtils {
    // Function to validate email
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    // Function to validate French phone number
    static func isValidFrenchPhoneNumber(_ number: String) -> Bool {
        let cleanedNumber = number.replacingOccurrences(of: " ", with: "")
        let phoneRegEx = #"^(0\d{9}|(\+33|0033)[1-9]\d{8})$"#
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: cleanedNumber)
    }

    // Function to validate and convert the amount string to Decimal
    static func validateAndConvertAmountString(_ amountString: String) -> Decimal? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        formatter.locale = Locale.current

        if let number = formatter.number(from: amountString) as? NSDecimalNumber {
            let decimalValue = number.decimalValue
            if decimalValue > 0 {
                return decimalValue
            }
        }
        return nil
    }
}