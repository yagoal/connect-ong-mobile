//
//  Animals.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 30/10/22.
//

import SwiftUI

struct AnimalsData: Codable {
    var animals: [Animal] = []
}

struct Animal: Codable, Equatable {
    var imgPath: String?
    var name = ""
    var gender = ""
    var breed = ""
    var weight: Double = 0
    var redempetionDate = ""
    var castration = false
    
    
//    let teste = Animal(name: "Gold", gender: "M", breed: "SRD", weight: 3.2, redempetionDate: "13/04/2022", castration: true)

}

struct AnimalData: Identifiable {
    var id: UUID = .init()
    var imgPath: String?
    var name: String
    var genden: String
    var breed: String
    var weight: Double
    var redempetionDate: String
    var castration: Bool
    
    init(animal: Animal) {
        imgPath = animal.imgPath
        name = animal.name
        genden = animal.gender
        breed = animal.breed
        weight = animal.weight
        redempetionDate = animal.redempetionDate
        castration = animal.castration
    }

//    static let teste = AnimalData(animal: .teste)
}
