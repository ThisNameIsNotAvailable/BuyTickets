//
//  Airport.swift
//  buyTickets
//
//  Created by Alex on 29/05/2022.
//

import Foundation

struct Airport: Codable, Equatable {
    var ID: Int?
    var Airport_name: String?
    var countryName: String?
    init(ID: Int?, Airport_name: String?, countryName: String?) {
        self.countryName = countryName
        self.ID = ID
        self.Airport_name = Airport_name
    }
}
