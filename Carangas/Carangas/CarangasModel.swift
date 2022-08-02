//
//  CarangasModel.swift
//  Carangas
//
//  Created by Jackeline Pires De Lima on 01/08/22.
//

import Foundation

class Carangas: Codable {
    var id: String?
    var brand: String = ""
    var gasType: Int = 0
    var name: String = ""
    var price: Double = 0.0

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brand, gasType, name, price
    }
    
    var gas: String {
        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Álcool"
        default:
            return "Gasolina"
        }
    }
}

struct Brand: Codable {
    var nome: String
}
