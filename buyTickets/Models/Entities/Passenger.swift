//
//  Passenger.swift
//  buyTickets
//
//  Created by Alexey Valevich on 06/05/2022.
//

import Foundation
struct Passenger: Codable {
    let passengerID: Int?
    let firstName: String?
    let lastName: String?
    let login: String?
    let password: String?
    let countryID: Int?
}
