//
//  Register+Models.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 24/9/22.
//

import Foundation

struct RegisterUser: Codable {
    var password = ""
    var confirmPassword = ""
    var name = ""
    var document = ""
    var gender = "Escolher"
    var birthDate: Date = .now
    var email = ""
    var telefone = ""
    var userAdress: UserAddress = .init()
}

struct UserAddress: Codable {
    var street: String = ""
    var number: String = ""
    var neighborhood: String = ""
    var zipCode: String = ""
    var state: String = ""
    var city: String = ""
    
    var address: Address = .empty
}

struct Address: Codable {
    var cep: String
    var logradouro: String
    var bairro: String
    var uf: String
    static let empty = Self.init(cep: "", logradouro: "", bairro: "", uf: "")
}
