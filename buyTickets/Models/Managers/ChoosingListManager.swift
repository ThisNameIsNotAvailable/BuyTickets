//
//  ChoosingListManager.swift
//  buyTickets
//
//  Created by Alex on 29/05/2022.
//

import Foundation
import CryptoKit

//MARK: - Airports Loader functions
extension ChoosingListManager {
    func performRequestAirport(parametrs: String, urlS: String) {
        if let url = URL(string: urlS) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let token = login! + hashP! + hashP!
            let hashedToken = SHA256.hash(data: Data(token.utf8)).description.replacingOccurrences(of: "SHA256 digest: ", with: "")
            let body = parametrs + "login=\(login!)&hashP=\(hashP!)&token=\(hashedToken)"
            let finalBody = body.data(using: .utf8)
            request.httpBody = finalBody
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    self.delegate?.showErrorMessage(message: "Failed to get data from the server. Check your connection.")
                }else {
                    if let data = data {
                        self.parseJSONAirport(data: data)
                    }else {
                        self.delegate?.showErrorMessage(message: "Failed to get data from the server. Check your connection.")
                    }
                }
            }.resume()
        }
    }
    
    func parseJSONAirport(data: Data) {
        let decoder = JSONDecoder()
        do {
            airports = try decoder.decode([Airport].self, from: data)
            filteredData = airports
            delegate?.updateTableView()
        }catch {
            delegate?.showErrorMessage(message: "Failed to parse data.")
        }
    }
}

//MARK: - Schedule Loader functions
extension ChoosingListManager {
    func performRequestDate(parametrs: String) {
        if let url = URL(string: K.URLs.downloadScheduleURL) {
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
                        self.parseJSONDate(data: data)
                    }else {
                        self.delegate?.showErrorMessage(message: "Failed to get data from the server. Check your connection.")
                    }
                }
            }.resume()
        }
    }
    
    func parseJSONDate(data: Data) {
        let decoder = JSONDecoder()
        do {
            routes = try decoder.decode([Route].self, from: data)
            filteredData = routes
            delegate?.updateTableView()
        }catch {
            delegate?.showErrorMessage(message: "Failed to parse data.")
        }
    }
}

class ChoosingListManager {
    var identifier: Int?
    var airports: [Airport]?
    var routes: [Route]?
    var filteredData: [Any]?
    weak var delegate: ChoosingListManagerDelegate?
    var selectedDeparturePlace: Int?
    var selectedDistanationPlace: Int?
    var selectedRoute: Int?
    var login: String?
    var hashP: String?
    
    func downloadData() {
        if identifier == K.ListType.Departure {
            performRequestAirport(parametrs: "", urlS: K.URLs.downloadStartingAirportsURL)
        }else if identifier == K.ListType.Destination {
            let parametrs = "start=\(selectedDeparturePlace!)&"
            let urlS = K.URLs.downloadTargetAirportsURL
            performRequestAirport(parametrs: parametrs, urlS: urlS)
        }else {
            let parametrs = "start=\(selectedDeparturePlace!)&target=\(selectedDistanationPlace!)"
            performRequestDate(parametrs: parametrs)
        }
    }
}
