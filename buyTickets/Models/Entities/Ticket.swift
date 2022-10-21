//
//  Ticket.swift
//  buyTickets
//
//

import Foundation

struct Ticket: Codable, Equatable {
    var start: String?
    var target: String?
    var numberOfSeat: Int?
    var dateOfDeparture: String?
    var canceled: Bool?
    
    init(start: String?, target: String?, numberOfSeat: Int?, dateOfDeparture: String?, canceled: Bool?) {
        self.start = start
        self.target = target
        self.numberOfSeat = numberOfSeat
        self.dateOfDeparture = dateOfDeparture
        self.canceled = canceled
    }
}
