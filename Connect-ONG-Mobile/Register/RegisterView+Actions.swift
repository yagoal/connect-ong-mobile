//
//  RegisterView+Actions.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 3/10/22.
//

import SwiftUI

extension RegisterView {
    
    func registerActionButton() {
        
        var errors = 0

        if !isValidEmailAddr(strToValidate: registerUser.email) {
            errors += 1
            invalidEmail = true
        }

        if !registerUser.document.isCPF {
            errors += 1
            invalidCPF = true
        }
        
        if !isPasswordValid(registerUser.password) {
            errors += 1
            invalidLabelPassword = true
        }
        
        if registerUser.password != registerUser.confirmPassword {
            errors += 1
            invalidLabelConfirmPassword = true
        }

        guard errors == 0 else {
            invalidForms = true
            return
        }

        isLoading = true
        invalidCPF = false
        invalidEmail = false
        invalidLabelPassword = false
        invalidLabelConfirmPassword = false
        
        setRegister()
    }
    
    private func setRegister() {
        Task { await
            service.register(
                user: registerUser,
                completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isLoading.toggle()
                        showToast.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        presentationMode.wrappedValue.dismiss()
                    }
            },
                completionError: {
                    isLoading = false
                    hasError = true
                }
            )
        }
    }
}
