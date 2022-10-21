//
//  MyTicketsManager.swift
//  buyTickets
//
//  Created by Alex on 29/05/2022.
//

import Foundation
import DropDown
import CryptoKit

class MyTicketsManager {
    var passengerID: Int?
    var delegate: MyTicketsManagerDelegate?
    var tickets: [Ticket]?
    var filteredData: [Ticket]?
    let dropDown = DropDown()
    var selectedTicketType: Int?
    var login: String?
    var hashP: String?
    
    func downloadTickets() {
        let parametrs = "passID=\(passengerID!)&login=\(login!)&hashP=\(hashP!)"
        performRequest(parametrs: parametrs)
    }
    
    func setUpFilterList(height: CGFloat) {
        dropDown.dataSource = ["Date", "Starting Airport"]
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: Int(height))
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                self.filteredData?.sort(by: { t1, t2 in
                    let date1 = t1.dateOfDeparture!
                    let date2 = t2.dateOfDeparture!
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = K.dateFormat
                    return dateFormatter.date(from: date1)! < dateFormatter.date(from: date2)!
                })
            }else {
                self.filteredData?.sort(by: { t1, t2 in
                    t1.start! < t2.start!
                })
            }
            delegate?.updateList()
        }
    }
    
    func performRequest(parametrs: String) {
        if let url = URL(string: K.URLs.downloadTicketsForPassengerURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let token = login! + hashP! + hashP!
            let hashedToken = SHA256.hash(data: Data(token.utf8)).description.replacingOccurrences(of: "SHA256 digest: ", with: "")
            let body = parametrs + "&token=\(hashedToken)"
            let finalBody = body.data(using: .utf8)
            request.httpBody = finalBody
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    self.delegate?.showErrorMessage(message: "Error occured when downloading data from the server.")
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
            tickets = try decoder.decode([Ticket].self, from: data)
            
            switch selectedTicketType! {
                case K.TicketType.canceled:
                    filteredData = tickets?.filter({ t in
                        t.canceled!
                    })
                case K.TicketType.active:
                    filteredData = tickets?.filter({ t in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = K.dateFormat
                        return dateFormatter.date(from: t.dateOfDeparture!)! > Date() && !t.canceled!
                    })
                default:
                    filteredData = tickets?.filter({ t in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = K.dateFormat
                        return dateFormatter.date(from: t.dateOfDeparture!)! < Date() && !t.canceled!
                    })
            }
            delegate?.updateList()
            delegate?.endRefreshing()
        }catch {
            delegate?.showErrorMessage(message: "Failed to parse data.")
        }
    }
}
