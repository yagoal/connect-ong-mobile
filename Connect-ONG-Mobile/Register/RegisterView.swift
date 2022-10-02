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
    
    @State var registerUser = RegisterUser()
    @State var isPasswordVisible = false
    @State var isConfirmPasswordVisible = false
    @State var showRegister = false
    @FocusState var cepFocused: Bool
    @State private var showToast = false

    @Environment(\.presentationMode) var presentationMode
    
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
        invalidLabel: String = "",
        placeHolder: String,
        invalidLabelVisible: Binding<Bool> = .constant(false),
        bind: Binding<String>,
        isCep: Bool = false
    ) -> some View {
        return VStack(alignment: .leading, spacing: isLargeScreen ? 20 : 10) {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                        .frame(height: isLargeScreen ? 35 : 10)
                    Spacer()
                    if invalidLabelVisible.wrappedValue {
                    Text(invalidLabel)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .font(.headline)
                        .frame(alignment: .leading)
                    }
                }

                HStack{
                    TextField(placeHolder, text: bind)
                        .autocapitalization(.none)
                    if isCep { searchAddressButton() }
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
        VStack(alignment: .leading) {
            makeFormRow(
                title: "Email",
                invalidLabel: "E-mail Inválido",
                placeHolder: "Digite seu e-mail",
                invalidLabelVisible: $invalidEmail,
                bind: $registerUser.email
            )
            .keyboardType(.emailAddress)

            makeFormRow(title: "Nome completo", placeHolder: "Digite nome completo", bind: $registerUser.name)

            makeGender()

            makeFormRow(
                title: "CPF",
                invalidLabel: "CPF Inválido",
                placeHolder: "Digite seu CPF",
                invalidLabelVisible: $invalidCPF,
                bind: $registerUser.document
            )
            .keyboardType(.numberPad)
            
            makeDateRow()

            makeFormRow(title: "Telefone", placeHolder: "Digite seu Telefone", bind: $registerUser.telefone)
                .keyboardType(.numberPad)
        }
    }
    
    let toast = SimpleToastOptions(
        alignment: .top,
        hideAfter: 2,
        backdrop: .black.opacity(0.5),
        animation: .default,
        modifierType: .slide
    )
    
    @State private var isLoading = false
    @State private var hasError = false
    @State private var invalidCPF = false
    @State private var invalidEmail = false
    @State private var invalidForms = false
    
    private func registerActionButton() {
        
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
        .simpleToast(isPresented: $showToast, options: toast, content: {
            stackToast(imageName: "checkmark.circle", message: "Usuário Cadastrado com sucesso, \nfaça o seu login!", color: .green)
        })
        .simpleToast(isPresented: $invalidForms, options: toast, content: {
            stackToast(imageName: "x.circle", message: "Dados inválidos, corrija-os!")
        })
        .simpleToast(isPresented: $hasError, options: toast, content: {
            stackToast(imageName: "x.circle", message: "Ocorreu um erro, tente novamente!")
        })
        
    }

    private func stackToast(imageName: String, message: String, color: Color = .red) -> some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(color)
            Text(message)
        }
        .padding()
        .background(.white)
        .cornerRadius(14)
    }
    
    @State private var invalidLabelPassword = false
    @State private var invalidLabelConfirmPassword = false

    private func passwordRows() -> some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Senha")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                        .frame(height: isLargeScreen ? 35 : 10)
                    Spacer()
                    if invalidLabelPassword {
                        Text("Senha inválida")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                            .font(.headline)
                            .frame(alignment: .leading)
                    }
                }
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
                HStack {
                    Text("Verificação de senha")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                        .frame(height: isLargeScreen ? 35 : 10)
                    Spacer()
                    if invalidLabelConfirmPassword {
                        Text("Os campos devem ser iguais")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                            .font(.headline)
                            .frame(alignment: .leading)
                    }
                }

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
