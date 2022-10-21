//
//  Constants.swift
//  buyTickets
//
//  Created by Alexey Valevich on 05/05/2022.
//

import Foundation

struct K {
    struct URLs {
        //http://localhost:8002/
        static let address = "http://localhost:8002/"
        static let getPassengerIDIfExistsURL = address + "getPassengerIDIfExists"
        static let verifyLoginURL = address + "canAddLogin"
        static let loadCountriesURL = address + "loadCountries"
        static let insertPassengerURL = address + "insertPassenger"
        static let downloadStartingAirportsURL = address + "getAllAirports"
        static let downloadTargetAirportsURL = address + "getTargetAirports"
        static let downloadScheduleURL = address + "getScheduleForRoute"
        static let downloadAvailableSeatsURL = address + "getAvailableSeats"
        static let insertTicketURL = address + "insertTicket"
        static let downloadTicketsForPassengerURL = address + "getTicketsForPassengerID"
        
    }
    
    struct Segues {
        static let loginToRegister = "LoginToRegister"
        static let loginToBooking = "LoginToBooking"
        static let bookingToAllTickets = "BookingToAllTickets"
        static let bookingToChoosingList = "BookingToChoosingList"
        
    }
    
    struct ListType {
        static let Departure = 1
        static let Destination = 2
        static let Dates = 3
    }
    
    struct TicketType {
        static let canceled = 1
        static let active = 2
        static let finished = 3
    }
    
    static let dateFormat = "yyyy-MM-dd HH:mm"
    static let token = "UJAIR2"
}
