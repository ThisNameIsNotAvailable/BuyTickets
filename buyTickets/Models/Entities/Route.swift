//
//  Route.swift
//  buyTickets
//
//  Created by Alex on 29/05/2022.
//

import Foundation

struct Route: Codable, Equatable {
    var ID: Int?
    var DateTimeOfDeparture: String?
    var Price: Float?
    init(ID: Int?, DateTimeOfDeparture: String?) {
        self.ID = ID
        self.DateTimeOfDeparture = DateTimeOfDeparture
    }
}
