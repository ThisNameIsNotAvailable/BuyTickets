//
//  BookingManager.swift
//  buyTickets
//
//  Created by Alex on 29/05/2022.
//

import Foundation
import CryptoKit

//MARK: - Seats Loader functions
extension BookingManager {
    func performRequest(parametrs: String) {
        if let url = URL(string: K.URLs.downloadAvailableSeatsURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let token = login! + hashP! + hashP!
            let hashedToken = SHA256.hash(data: Data(token.utf8)).description.replacingOccurrences(of: "SHA256 digest: ", with: "")
            let body = parametrs + "&token=\(hashedToken)&login=\(login!)&hashP=\(hashP!)"
            let finalBody = body.data(using: .utf8)
            request.httpBody = finalBody
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    self.delegate?.showErrorMessage(message: "Failed to get data from the server. Check your connection.")
                }else {
                    if let data = data {
                        self.parseJSON(data: data)
                    }
                }
            }.resume()
        }
    }
    
    func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        do {
            availableSeats = try decoder.decode(Seats.self, from: data).seats
            selectedSeat = availableSeats?[0]
            delegate?.updatePicker()
        }catch {
            delegate?.showErrorMessage(message: "Error occured when parsing data.")
        }
    }
}

//MARK: - Insertion of Ticket functions
extension BookingManager {
    func insertTicket() {
        if let selectedSeat = selectedSeat {
            let parametrs = "flightID=\(selectedRoute!.ID!)&numberOfSeat=\(selectedSeat)&passengerID=\(passengerID!)&login=\(login!)&hashP=\(hashP!)"
            performRequestTicket(parametrs: parametrs)
        }
    }
    
    func performRequestTicket(parametrs: String) {
        if let url = URL(string: K.URLs.insertTicketURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let token = login! + hashP! + hashP!
            let hashedToken = SHA256.hash(data: Data(token.utf8)).description.replacingOccurrences(of: "SHA256 digest: ", with: "")
            let body = parametrs + "&token=\(hashedToken)"
            let finalBody = body.data(using: .utf8)
            request.httpBody = finalBody
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    self.delegate?.showErrorMessage(message: "Failed to download data from the server. Try again.")
                }else {
                    if let data = data {
                        self.parseJSONTicket(data: data)
                    }
                }
            }.resume()
        }
    }
    
    func parseJSONTicket(data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Answer.self, from: data)
            if decodedData.answer == 0 {
                delegate?.showErrorMessage(message: "Ticket was not added. Try again.")
            }else {
                delegate?.showSuccessMessage(message: "Ticket was successfully added.")
            }
            delegate?.clearSeatsPicker()
            delegate?.clearDatesField()
            delegate?.clearDestinationField()
            delegate?.clearDepartureField()
        }catch {
            delegate?.showErrorMessage(message: "Error occured when parsing data.")
        }
    }
}

class BookingManager {
    var selectedField: Int?
    weak var delegate: BookingManagerDelegate?
    var selectedDeparturePlace: Airport?
    var selectedDistanationPlace: Airport?
    var selectedRoute: Route?
    var availableSeats: [Int]?
    var selectedSeat: Int?
    var passengerID: Int?
    var login: String?
    var hashP: String?
    
    func canPerformSegue(destText: String?, depText: String?) -> Bool {
        let destText = destText ?? ""
        let depText = depText ?? ""
        
        if selectedField == K.ListType.Departure {
            delegate?.clearDestinationField()
            delegate?.clearDatesField()
            delegate?.clearSeatsPicker()
            return true
        }else if depText != "" && selectedField == K.ListType.Destination {
            delegate?.clearDatesField()
            delegate?.clearSeatsPicker()
            return true
        }else if destText != "" && selectedField == K.ListType.Dates {
            delegate?.clearSeatsPicker()
            return true
        }else {
            delegate?.showErrorMessage(message: "Choose something in previous fields.")
            return false
        }
    }
}
