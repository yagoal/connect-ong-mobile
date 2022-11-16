//
//  Login+Models.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 12/10/22.
//

import Foundation

struct LoginUser: Codable {
    var id = 0
    var imgPath = ""
    var name = ""
    var email = ""
    var gender = ""
    var document = ""
    var phone1: phone = .init()
    var birthDate = ""
    var address: AddressGet = .init()
}

struct AddressGet: Codable {
    var street: String = ""
    var number: String = ""
    var neighborhood: String = ""
    var zipCode: String = ""
    var state: String = ""
    var city: String = ""
}

struct phone: Codable {
    var ddd = ""
    var number = ""
}
