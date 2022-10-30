//
//  ProfileView.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 12/10/22.
//

import SwiftUI

struct ProfileView: View {
    
    var user: LoginUser
    
    init(user: LoginUser) {
        self.user = user
    }
    
    @State var showAdoptions = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("backgroundLogin")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: widthScreen)
                .ignoresSafeArea()
                .opacity(0.3)
            VStack {
                Text("Meu Perfil")
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .frame(height: isLargeScreen ? 70 : 45)
                ScrollView {
                    personalInfosStack()
                    Spacer(minLength: 25)
                    addressStack()
                    Spacer(minLength: 25)
                    contactStack()
                }
                .padding(.vertical)
                Button(action: {
                    showAdoptions = true
                }, label: {
                    Text("Adotar")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: isLargeScreen ? 70 : 45)
                        .background(Color.blue.opacity(0.9))
                        .cornerRadius(8)
                })
                .padding(.top)
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showAdoptions) {
            AdoptionsView()
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

