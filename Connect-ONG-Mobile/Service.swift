//
//  Networking.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 7/9/22.
//

import Foundation



class Service: ObservableObject {
    @Published var registerUser = RegisterUser()

    func register(user: RegisterUser, completion: @escaping () -> Void) async {
        
        let baseURL = "http://localhost:8080/connect-ong"
        let path = "/RegisterJSON"

        guard let url = URL(string: baseURL + path) else { return }
        
        let address: [String: String] = [
            "street": user.userAdress.street,
            "number": user.userAdress.number,
            "neighborhood": user.userAdress.neighborhood,
            "zipCode": user.userAdress.zipCode,
            "state": user.userAdress.state,
            "city": user.userAdress.city,
        ]
        
        let ddd = user.telefone.prefix(2)
        let num = user.telefone.suffix(9)
        
        let finalPhone: [String: Any] = [
            "ddd": ddd,
            "telefone": num
        ]

        let body: [String: Any] = [
            "imagePath": "",
            "email": user.email,
            "phone1": finalPhone,
            "phone2": finalPhone,
            "name": user.name,
            "birthDate": user.birthDate.formatted(.iso8601),
            "document": user.document,
            "gender": user.gender,
            "password" : user.password,
            "address": address
        ]

        let finalBody = try? JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(RegisterUser.self, from: data)
                print(result)
            } catch (let error) {
                print("error:", error.localizedDescription)
            }
            completion()
        }.resume()

    }
    
    var address: Address = .empty
    
    func getAddress(cep: String, completion: @escaping () -> Void) {
        
        let baseURL = "https://viacep.com.br/ws"
        let path = "/\(cep)/json"
        
        guard let url = URL(string: baseURL+path) else {
            completion()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(Address.self, from: data)
                self.address = result
            } catch {
                print (error.localizedDescription)
            }
            completion()
        }
        
        task.resume()
        
    }
}

extension DateFormatter {
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_us_POSIX")
        return formatter
    }()
}
