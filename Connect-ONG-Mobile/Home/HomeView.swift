//
//  ContentView.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 28/8/22.
//

import SwiftUI
import CoreData

public let widthScreen = UIScreen.main.bounds.width
public let heightScreen = UIScreen.main.bounds.height

public var isLargeScreen: Bool {
    heightScreen > 720
}

private let service = Service()

struct HomeView: View {
    @State var email = ""
    @State var password = ""
    @State var isPasswordVisible = false
    @State var showRegister = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("backgroundLogin")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: widthScreen)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: isLargeScreen ? 12 : 5) {
                Text("Bem vindo ao \nConnect-ONG!")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .frame(height: isLargeScreen ? 70 : 50)
                    .foregroundColor(.blue)
                    .padding()

                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                        .frame(height: isLargeScreen ? 35 : 10)


                    TextField("Digite seu e-mail", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
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
                            TextField("Digite sua senha", text: $password)
                        } else {
                            SecureField("Digite sua senha", text: $password)
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

                HStack {
                    Spacer()

                    Button(action: {}, label: {
                        Text("Esqueci a senha")
                            .foregroundColor(.blue)
                    })
                }

                Button(action: {}, label: {
                    Text("Acessar")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: isLargeScreen ? 70 : 45)
                        .background(Color.blue.opacity(0.9))
                        .cornerRadius(8)
                })
                .padding(.top)

                Button(action: { showRegister = true }, label: {
                    Text("Ainda não se cadastrou? Clique aqui")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: isLargeScreen ? 70 : 45)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(8)
                        .lineLimit(2)
                })

            }
            .frame(height: isLargeScreen ? heightScreen*3/5 : heightScreen*2/3)
            .padding(24)
            .background(Color.cyan.opacity(0.35)) // temp
            .cornerRadius(15)
        }
        .ignoresSafeArea(edges: .bottom)
        .frame(width: widthScreen, height: heightScreen, alignment: .center)
        .sheet(isPresented: $showRegister) {
            RegisterView()
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style = UIBlurEffect.Style.regular

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


                        

//NavigationView {
//}
//.padding()
//.background(Color.cyan.opacity(0.35))
//.ignoresSafeArea(edges: .bottom)
//.frame(width: widthScreen, height: heightScreen, alignment: .center)
//.navigationTitle("Cadastre-se")
//.navigationBarTitleDisplayMode(.large)
//.toolbar {
//    ToolbarItem(placement: .navigationBarTrailing, content: {
//        Button(
//            action: { dismiss() },
//            label: {
//                Image("closeButton")
//                    .frame(width: 3, height: 3)
//            }
//        )
//    })
//}
