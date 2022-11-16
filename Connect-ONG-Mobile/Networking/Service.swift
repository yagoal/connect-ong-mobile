//
//  Networking.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 7/9/22.
//

import Foundation

public class Service: ObservableObject {

    private(set) var loginUser = LoginUser()

    static let baseUrl = "https://connect-ong-pa.herokuapp.com"

    func getUser(
        login: String,
        password: String,
        completion: @escaping () -> Void,
        completionError: @escaping () -> Void
    ) {

        let path = "/UserLoginControllerJSON"

        guard let url = URL(string: Service.baseUrl + path) else { return }

        let body : [String: String] = [
            "login": login,
            "password": password
        ]

        let finalBody = try? JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                completionError()
                return
            }
            do {
                let result = try JSONDecoder().decode(LoginUser.self, from: data)
                self.loginUser = result
                completion()
            } catch {
                print (error.localizedDescription)
                completionError()
            }
        }

        task.resume()

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

    func register(
        user: RegisterUser,
        completion: @escaping () -> Void,
        completionError: @escaping () -> Void
    ) async {

        let path = "/RegisterJSON"

        guard let url = URL(string: Service.baseUrl + path) else { return }

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
            "number": num
        ]

        let body: [String: Any] = [
            "imagePath": "",
            "email": user.email,
            "phone1": finalPhone,
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

            if let error = error {
                completionError()
                print("error:", error.localizedDescription)
                return
            }

            completion()
        }.resume()

    }

    private(set) var animalsData: AnimalsData = .init()

    func getAnimals(completion: @escaping () -> Void) {

        let path = "/OngAnimalsControllerJSON"

        guard let url = URL(string: Service.baseUrl + path) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(AnimalsData.self, from: data)
                self.animalsData = result
                print(self.animalsData)
            } catch {
                print (error.localizedDescription)
            }
            completion()
        }

        task.resume()

    }
    
    func toAdopt(
        userId: Int,
        animalId: Int,
        completion: @escaping () -> Void,
        completionError: @escaping () -> Void
    ) async {

        let path = "/OngAnimalsControllerJSON"

        guard let url = URL(string: Service.baseUrl + path) else { return }

        let body: [String: Any] = [
            "idAnimal": animalId,
            "idUser": userId
        ]

        let finalBody = try? JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completionError()
                print("error:", error.localizedDescription)
                return
            }

            completion()
        }.resume()

    }
    
    
}

public extension DateFormatter {
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_us_POSIX")
        return formatter
    }()
}

public extension String {
    var dateFromISO8601: DateFormatter {
        return DateFormatter.customFormatter
    }
}
