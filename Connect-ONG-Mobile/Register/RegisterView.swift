//
//  RegisterView.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 28/8/22.
//

import SwiftUI
import SimpleToast
import SwiftUITooltip

struct RegisterView: View {
    
    @State internal var registerUser = RegisterUser()
    @State internal var isPasswordVisible = false
    @State internal var isConfirmPasswordVisible = false
    @State internal var showRegister = false
    @State internal var showToast = false
    @State internal var isLoading = false
    @State internal var hasError = false
    @State internal var invalidCPF = false
    @State internal var invalidEmail = false
    @State internal var invalidForms = false
    @State internal var invalidLabelPassword = false
    @State internal var invalidLabelConfirmPassword = false

    @Environment(\.presentationMode) var presentationMode

    var service = Service()

    var body: some View {
        ZStack {
            Image("backgroundLogin")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: widthScreen)
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    Text("Preencha as informações")
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .frame(height: isLargeScreen ? 70 : 45)

                    personalDataStacks()
                    addressStack()
                    passwordRows()

                }
                .padding(24)
                .background(Color.cyan.opacity(0.6))
                .cornerRadius(15)
                
                Button(action: {
                    registerActionButton()
                }, label: {
                    Text("Cadastra-se")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: isLargeScreen ? 70 : 45)
                        .background(Color.blue.opacity(0.9))
                        .cornerRadius(8)
                })
                .padding()
            }
            .padding(24)
            
            if isLoading {
            ProgressView()
                .scaleEffect(3)
            }
        }
        .simpleToast(isPresented: $showToast, options: toastConfig, content: {
            stackToast(imageName: "checkmark.circle", message: "Usuário Cadastrado com sucesso, \nfaça o seu login!", color: .green)
        })
        .simpleToast(isPresented: $invalidForms, options: toastConfig, content: {
            stackToast(imageName: "x.circle", message: "Dados inválidos, corrija-os!")
        })
        .simpleToast(isPresented: $hasError, options: toastConfig, content: {
            stackToast(imageName: "x.circle", message: "Ocorreu um erro, tente novamente!")
        })
        
    }
}

struct RegisterPreview: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
