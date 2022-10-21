//
//  Country.swift
//  buyTickets
//
//

import UIKit

class Country: Codable {
    var ID: Int?
    var countryName: String?
    init(ID: Int?, countryName: String?) {
        self.ID = ID
        self.countryName = countryName
    }
}
