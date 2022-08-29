//
//  RegisterView.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 28/8/22.
//

import SwiftUI

struct RegisterUser {
    var name = ""
    var document = ""
    var gender = ""
    var dataDeNascimento = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
}


struct RegisterView: View {

    @State var registerUser = RegisterUser()

    @State var isPasswordVisible = false
    @State var isConfirmPasswordVisible = false
    @State var showRegister = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Image("backgroundLogin")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: widthScreen)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: isLargeScreen ? 20 : 10) {
                        VStack(alignment: .leading) {
                            Text("Email")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                                .frame(height: isLargeScreen ? 35 : 10)


                            TextField("Digite seu e-mail", text: $registerUser.email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text("Nome completo")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                                .frame(height: isLargeScreen ? 35 : 10)


                            TextField("Digite nome completo", text: $registerUser.name)
                                .autocapitalization(.none)
                                .keyboardType(.default)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text("CPF")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                                .frame(height: isLargeScreen ? 35 : 10)


                            TextField("Digite seu CPF", text: $registerUser.document)
                                .autocapitalization(.none)
                                .keyboardType(.numberPad)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text("Senha")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                                .frame(height: isLargeScreen ? 35 : 10)

                            HStack {
                                if isPasswordVisible {
                                    TextField("Digite sua senha", text: $registerUser.password)
                                } else {
                                    SecureField("Digite sua senha", text: $registerUser.password)
                                }

                                Button(action: {
                                    isPasswordVisible.toggle()
                                }, label: {
                                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                        .foregroundColor(.black)
                                })
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text("Verificação de senha")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                                .frame(height: isLargeScreen ? 35 : 10)

                            HStack {
                                if isConfirmPasswordVisible {
                                    TextField("Confirme sua senha", text: $registerUser.confirmPassword)
                                } else {
                                    SecureField("Confirme sua senha", text: $registerUser.confirmPassword)
                                }

                                Button(action: {
                                    isConfirmPasswordVisible.toggle()
                                }, label: {
                                    Image(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
                                        .foregroundColor(.black)
                                })
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)

                        Button(action: {}, label: {
                            Text("Cadastra-se")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .frame(height: isLargeScreen ? 70 : 45)
                                .background(Color.blue.opacity(0.9))
                                .cornerRadius(8)
                        })
                        .padding(.top)
                    }
                    .frame(height: heightScreen)
                    .padding(24)
                    .background(Color.cyan.opacity(0.35))
                    .cornerRadius(15)
                }
            }
            .background(Color.cyan.opacity(0.35))
            .ignoresSafeArea(edges: .bottom)
            .frame(width: widthScreen, height: heightScreen, alignment: .center)
            .navigationTitle("Cadastre-se")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(
                        action: { dismiss() },
                        label: {
                            Image("closeButton")
                                .frame(width: 3, height: 3)
                        }
                    )
                })
            }
        }
    }
}

struct registerPreview: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
