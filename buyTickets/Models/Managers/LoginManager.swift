//
//  LoginManager.swift
//  buyTickets
//
//  Created by Alexey Valevich on 05/05/2022.
//

import Foundation
import CryptoKit

class LoginManager {
    var passengerID: Int?
    weak var delegate: LoginManagerDelegate?
    var login: String?
    var hashP: String?
    
    func checkCredentials(login: String, password: String) {
        if login.contains(" ") {
            delegate?.showErrorMessage(message: "Login cannot contain spaces.")
        }
        if password == "" {
            delegate?.showErrorMessage(message: "Enter your login.")
        }else if login == "" {
            delegate?.showErrorMessage(message: "Enter your password.")
        }else {
            let hashedPassword = SHA256.hash(data: Data(password.utf8)).description.replacingOccurrences(of: "SHA256 digest: ", with: "")
            performRequest(login: login, password: hashedPassword)
        }
    }
    
    func performRequest(login: String, password: String) {
        if let url = URL(string: K.URLs.getPassengerIDIfExistsURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let token = login + password + password
            let hashedToken = SHA256.hash(data: Data(token.utf8)).description.replacingOccurrences(of: "SHA256 digest: ", with: "")
            let body = "login=\(login)&hashP=\(password)" + "&token=\(hashedToken)"
            let finalBody = body.data(using: .utf8)
            request.httpBody = finalBody
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if(error != nil) {
                    print(error)
                    self.delegate?.showErrorMessage(message: "Failed to load data.")
                }else {
                    if let data = data {
                        if let parsedData = self.parseJSON(data: data) {
                            if(parsedData == -1) {
                                self.delegate?.showErrorMessage(message: "Invalid login or password.")
                            }else {
                                self.login = login
                                self.hashP = password
                                self.delegate?.updateController()
                            }
                        }
                    }
                }
            }.resume()
            
        }
    }
    
    func parseJSON(data: Data) -> Int? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Passenger.self, from: data)
            self.passengerID = decodedData.passengerID
            return decodedData.passengerID
        } catch {
            delegate?.showErrorMessage(message: "Error occured when parsing data.")
        }
        return nil
    }
}
