//
//  RegisterView.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 28/8/22.
//

import SwiftUI

struct RegisterView: View {
    
    @State var registerUser = RegisterUser()
    @State var isPasswordVisible = false
    @State var isConfirmPasswordVisible = false
    @State var showRegister = false
    @FocusState var cepFocused: Bool

    @Environment(\.dismiss)
    private var dismiss
    
    var service = Service()

    private let date: DateFormatter = .customFormatter

    private func searchAddressButton() -> some View {
        Button(
            action: {
                DispatchQueue.main.async {
                    let cep = registerUser.userAdress.address.cep
                    service.getAddress(cep: cep, completion: {
                        self.registerUser.userAdress.street = self.service.address.logradouro
                        self.registerUser.userAdress.zipCode = self.service.address.cep
                        self.registerUser.userAdress.neighborhood = self.service.address.bairro
                        self.registerUser.userAdress.state = self.service.address.uf
                        
                    })
                }
            },
            label: {
                Label("", systemImage: "magnifyingglass")
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
            }
        )
    }

    private func makeFormRow(
        title: String,
        placeHolder: String,
        bind: Binding<String>,
        isCep: Bool = false,
        isGender: Bool = false
    ) -> some View {
        return VStack(alignment: .leading, spacing: isLargeScreen ? 20 : 10) {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                    .frame(height: isLargeScreen ? 35 : 10)

                HStack{
                    TextField(placeHolder, text: bind)
                        .autocapitalization(.none)
                    if isCep { searchAddressButton() }
                    if isGender {  makeGender() }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
    }
    
    private func makeDateRow() -> some View {
        VStack(alignment: .leading, spacing: isLargeScreen ? 5 : 2) {
            Text("Data de Nascimento")
                .foregroundColor(.blue)
                .fontWeight(.semibold)
                .frame(height: isLargeScreen ? 35 : 10)
                .padding(.all, 12)
            
            DatePicker("Escolha a data", selection: $registerUser.birthDate, displayedComponents: [.date])
                .menuStyle(.automatic)
                .datePickerStyle(.automatic)
                .foregroundColor(.gray.opacity(0.6))
                .cornerRadius(8)
                .padding(.all, 12)
        }
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private func renderNameGender() -> String {
        guard registerUser.gender != "Escolher" else {
            return "Escolher"
        }
        
        if registerUser.gender == "M" {
            return "Masculino"
        }
        
        return "Feminino"
    }
    
    private func makeGender() -> some View {
        VStack(alignment: .leading, spacing: isLargeScreen ? 20 : 10) {
            Text("Gênero")
                .foregroundColor(.blue)
                .fontWeight(.semibold)
                .frame(height: isLargeScreen ? 35 : 10)
            Menu {
                Button(
                    action: { registerUser.gender = "M" },
                    label: {
                        Text("Masculino")
                            .foregroundColor(.yellow)
                    }
                )
                Button(
                    action: { registerUser.gender = "F" },
                    label: {
                        Text("Feminino")
                            .foregroundColor(.yellow)
                    }
                )
            } label: {
                Label(renderNameGender(), systemImage: "arrow.down")
            }
        }
        .padding()
        .frame(width: widthScreen-24, alignment: .leading)
        .background(Color.white)
        .cornerRadius(8)
    }
    
    private func addressStack() -> some View {
        VStack {
            makeFormRow(title: "CEP", placeHolder: "Digite seu CEP", bind: $registerUser.userAdress.address.cep, isCep: true)
                .keyboardType(.numberPad)
            makeFormRow(title: "Logradouro", placeHolder: "Busque utilizando o CEP", bind: $registerUser.userAdress.street)
            makeFormRow(title: "Número", placeHolder: "Digite o número", bind: $registerUser.userAdress.number)
            makeFormRow(title: "Bairro", placeHolder: "Busque utilizando o CEP", bind: $registerUser.userAdress.neighborhood)
            makeFormRow(title: "UF", placeHolder: "Busque utilizando o CEP", bind: $registerUser.userAdress.state)
        }
    }
    
    private func personalDataStacks() -> some View {
        VStack{
            makeFormRow(title: "Email", placeHolder: "Digite seu e-mail", bind: $registerUser.email)
                .keyboardType(.emailAddress)

            makeFormRow(title: "Nome completo", placeHolder: "Digite nome completo", bind: $registerUser.name)
            makeGender()
            makeFormRow(title: "CPF", placeHolder: "Digite seu CPF", bind: $registerUser.document)
                .keyboardType(.numberPad)
            makeDateRow()
            makeFormRow(title: "Telefone", placeHolder: "Digite seu Telefone", bind: $registerUser.telefone)
                .keyboardType(.numberPad)
        }
    }

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
                    service.register(user: registerUser) {
                        dismiss()
                    }
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
        }
    }
    
    private func passwordRows() -> some View{
        VStack {
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
            .keyboardType(.asciiCapable)
            
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
            .keyboardType(.asciiCapable)
        }
    }
        
}

struct registerPreview: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
