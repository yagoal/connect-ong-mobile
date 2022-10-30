//
//  AdoptionsView.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 30/10/22.
//

import SwiftUI

struct AdoptionsView: View {

    private let service = Service()

    @State var animals: [AnimalData] = []
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("backgroundLogin")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: widthScreen)
                .ignoresSafeArea()
                .opacity(0.3)
            VStack {
                Text("Animais Disponíveis")
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .frame(height: isLargeScreen ? 70 : 45)
                List{
                    ForEach(animals) { section in
                        animalModal(animal: section)
                    }
                }
                .listStyle(.plain)
                .opacity(0.8)
            }
        }
        .onAppear {
            service.getAnimals {
                animals = loadAnimals()
            }
        }
    }

    private func loadAnimals() -> [AnimalData] {
        service.animalsData.animals.map(AnimalData.init(animal:))
    }

    private func animalModal(animal: AnimalData) -> some View {
        VStack {
            Image("noPhoto")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
                .ignoresSafeArea()
                .padding()
            infoRow(title: "Nome", bind: animal.name)
            infoRow(title: "Sexo", bind: animal.genden)
            infoRow(title: "Raça", bind: animal.breed)
            infoRow(title: "Peso", bind: animal.weight.formatted())
            infoRow(title: "Data do Regaste", bind: animal.redempetionDate)
            infoRow(title: "Castração", bind: animal.castration ? "Realizada" : "Pendente")
        }
        .background(.blue.opacity(0.3))
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

struct AdoptionsPreview: PreviewProvider {
    static var previews: some View {
        AdoptionsView()
    }
}
