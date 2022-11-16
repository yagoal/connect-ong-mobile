//
//  ProfileView.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 12/10/22.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {

    var user: LoginUser
    public static var userId = 0

    init(user: LoginUser) {
        self.user = user
        Self.userId = user.id
    }

    @State var showAdoptions = false
    @State var showSheetLogout = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("backgroundLogin")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: widthScreen)
                .ignoresSafeArea()
                .opacity(0.3)
            VStack(spacing: 10) {
                Text("Meu Perfil")
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .frame(height: isLargeScreen ? 70 : 45)
                ScrollView {
                    renderPhoto().padding()
                    Spacer(minLength: 25)
                    personalInfosStack().padding()
                    Spacer(minLength: 25)
                    addressStack().padding()
                    Spacer(minLength: 25)
                    contactStack().padding()
                }
                .padding(.vertical)
                HStack {
                    Button(action: {
                        showSheetLogout = true
                    }, label: {
                        Text("Deslogar")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: isLargeScreen ? 60 : 45)
                            .background(Color.red.opacity(0.9))
                            .cornerRadius(10)
                            .padding()
                    })
                    .padding(.top)
                    .padding(.horizontal)
                    Button(action: {
                        showAdoptions = true
                    }, label: {
                        Text("Animais Disponíveis")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: isLargeScreen ? 60 : 45)
                            .background(Color.blue.opacity(0.9))
                            .cornerRadius(10)
                            .padding()
                    })
                    .padding(.top)
                    .padding(.horizontal)
                }
                .sheet(isPresented: $showSheetLogout) {
                    if #available(iOS 16.0, *) {
                        VStack {
                            Text("Tem certeza que deseja deslogar?")
                                .padding()
                            HStack(alignment: .center) {
                                Button(action: {
                                    showSheetLogout = false
                                }, label: {
                                    Text("Não")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: isLargeScreen ? 60 : 45)
                                        .background(Color.red.opacity(0.9))
                                        .cornerRadius(8)
                                })
                                .padding(.top)
                                .padding(.horizontal)
                                Button(action: {
                                    showSheetLogout = false
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Text("Sim")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: isLargeScreen ? 60 : 45)
                                        .background(Color.blue.opacity(0.9))
                                        .cornerRadius(8)
                                })
                                .padding(.top)
                                .padding(.horizontal)
                            }
                        }
                        .presentationDetents([.height(200), .medium])
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            .background(Color.white.opacity(0.6))
        }
        .sheet(isPresented: $showAdoptions) {
            AdoptionsView()
        }
    }
    
    private func renderPhoto() -> some View {
        print(Service.baseUrl + user.imgPath)
        return VStack {
            if !user.imgPath.isEmpty {
                AsyncImage(url: URL(string: Service.baseUrl + "/\(user.imgPath)"), content: { image in
                        image.resizable()
                        }, placeholder: {
                            ProgressView()
                                .scaleEffect(2)
                        })
                            .frame(width: 350, height: 350)
                            .clipShape(Circle())
                Spacer(minLength: 10)
            } else {
                Image("noPhoto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .ignoresSafeArea()
                    .padding(.horizontal)
            }
        }
    }

    private func personalInfosStack() -> some View {

        return VStack(spacing: 10) {
            Text("Dados Pessoais")
                .bold()
                .font(.title3)
            infoRow(title: "Nome:", bind: user.name)
            infoRow(title: "CPF:", bind: user.document)
            infoRow(title: "Sexo:", bind: user.gender)
            infoRow(title: "Data de Nascimento:", bind: user.birthDate)
        }
        .background(.blue.opacity(0.4))
        .cornerRadius(12)
    }

    private func addressStack() -> some View {
        return VStack(spacing: 10) {
            Text("Endereço")
                .bold()
                .font(.title3)
            infoRow(title: "Logradouro:", bind: user.address.street)
            infoRow(title: "Número:", bind: user.address.number)
            infoRow(title: "Bairro:", bind: user.address.neighborhood)
            infoRow(title: "Cidade:", bind: user.address.city + " - " + user.address.state)
            infoRow(title: "CEP:", bind: user.address.zipCode)
        }
        .padding()
        .background(.blue.opacity(0.4))
        .cornerRadius(12)
    }

    private func contactStack() -> some View {
        VStack(spacing: 10) {
            Text("Dados de Contato")
                .bold()
                .font(.title3)
            infoRow(title: "E-mail:", bind: user.email)
            infoRow(title: "Telefone:", bind: user.phone1.ddd + user.phone1.number)
        }
        .padding()
        .background(.blue.opacity(0.4))
        .cornerRadius(12)
    }

    private func infoRow(title: String, bind: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(bind)
                .font(.headline)
        }
        .padding(4)
    }
}

struct ProfilePreviews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: .init())
    }
}

