//
//  AdoptionsView.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 30/10/22.
//

import SwiftUI
import SimpleToast

struct AdoptionsView: View {

    private let service = Service()

    @State internal var isLoading = false
    @State internal var hasError = false
    @State internal var showSuccess = false
    @State internal var showSheet = false
    @Environment(\.presentationMode) var presentationMode

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
        .padding(24)
        .cornerRadius(15)
        .onAppear {
            service.getAnimals {
                animals = loadAnimals()
            }
        }
        if isLoading {
            ProgressView()
                .scaleEffect(3)
        }
    }

    private func loadAnimals() -> [AnimalData] {
        service.animalsData.animals.map(AnimalData.init(animal:))
    }

    private func animalModal(animal: AnimalData) -> some View {
        print(Service.baseUrl + (animal.imgPath ?? ""))
        return VStack {
            if let imgPath = animal.imgPath {
                Spacer(minLength: 10)
                AsyncImage(url: URL(string: Service.baseUrl + "/\(imgPath)"), content: { image in
                        image.resizable()
                        }, placeholder: {
                            Image("noPhoto")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                                .ignoresSafeArea()
                                .padding(.horizontal)
                        })
                            .frame(width: 250, height: 250)
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
            infoRow(title: "Nome", bind: animal.name)
            infoRow(title: "Sexo", bind: animal.genden)
            infoRow(title: "Raça", bind: animal.breed)
            infoRow(title: "Peso", bind: animal.weight.formatted())
            infoRow(title: "Data do Regaste", bind: animal.redempetionDate)
            infoRow(title: "Castração", bind: animal.castration ? "Realizada" : "Pendente")
            Button(action: {
                showSheet = true
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
        .padding()
        .background(.blue.opacity(0.3))
        .cornerRadius(12)
        .sheet(isPresented: $showSuccess) {
            if #available(iOS 16.0, *) {
                Text("Reserva de adoção de \(animal.name) realizada com sucesso, dirija-se a ONG responsável parar prosseguir")
                    .padding()
                    .presentationDetents([.height(200), .medium])
            }
        }
        .sheet(isPresented: $showSheet) {
            if #available(iOS 16.0, *) {
                VStack {
                    Text("Ao clicar em SIM você aceita todas as diretrizes de adoção da ONG, tem certeza que deseja continuar?")
                        .font(.headline)
                        .padding()
                    HStack {
                        Button(action: {
                            showSheet = false
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
                            setAdoption(animal)
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

    private func setAdoption(_ animal: AnimalData) {
        Task { await
            service.toAdopt(
                userId: ProfileView.userId,
                animalId: animal.animalId,
                completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading.toggle()
                        showSheet = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSuccess = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                        isLoading = false
                        showSuccess = false
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                completionError: { hasError.toggle() }
            )
        }
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
    
    private var toastConfig: SimpleToastOptions {
        SimpleToastOptions(
            alignment: .top,
            hideAfter: 2,
            backdrop: .black.opacity(0.5),
            animation: .default,
            modifierType: .fade
        )
    }

    private func infoRow(title: String, bind: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(bind)
                .font(.headline)
        }
        .padding(6)
    }
}

struct AdoptionsPreview: PreviewProvider {
    static var previews: some View {
        AdoptionsView()
    }
}
