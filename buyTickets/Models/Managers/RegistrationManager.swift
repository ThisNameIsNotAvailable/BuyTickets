//
//  RegistrationManager.swift
//  buyTickets
//
//  Created by Alexey Valevich on 06/05/2022.
//

import Foundation
import CryptoKit

protocol CountryLoader {
    func downloadCountries()
    func performRequestCountry(urlS: String)
    func parseJSONCountry(data: Data)
}

protocol PassengerInserter {
    func insertPassenger(firstName: String, lastName: String, login: String, password: String, repeatPassword: String)
    func performRequestPassenger(parametrs: String)
    func parseJSONPassenger(data: Data)
}

class RegistrationManager {
    var countries: [String : Int] = [String : Int]()
    var pickerData = [String]()
    var selectedCountry: Int?
    weak var delegate: RegistrationManagerDelegate?
    
    func setSelectedCountry(to: String) {
        selectedCountry = countries[to]
    }
}

//MARK: - Passenger insertion
extension RegistrationManager: PassengerInserter {
    func insertPassenger(firstName: String, lastName: String, login: String, password: String, repeatPassword: String) {
        var message: String = ""
        if firstName.replacingOccurrences(of: " ", with: "") == "" {
            message = "Enter your first name."
        }else if lastName.replacingOccurrences(of: " ", with: "") == "" {
            message = "Enter your last name."
        }else if login.contains(" ") {
            message = "Login cannot contain spaces."
        }else if password == "" {
            message = "Enter password."
        }else if repeatPassword == "" {
            message = "Confirm password."
        }else if selectedCountry == nil {
            message = "Choose a country of origin."
        }else if repeatPassword != password {
            message = "Password and confirm password does not match."
        }else if password.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
            message = "Password must contain at least one digit."
        }else if password.count < 8 {
            message = "Password is too short."
        }else if password.count > 20 {
            message = "Password is too long."
        }
        if message != "" {
            delegate?.showErrorMessage(message: message)
        }else {
            //dodać sól
            let hashedPassword = SHA256.hash(data: Data(password.utf8)).description.replacingOccurrences(of: "SHA256 digest: ", with: "")
            let parametrs = "firstN=\(firstName)&lastN=\(lastName)&password=\(hashedPassword)&login=\(login)&countryID=\(selectedCountry!)"
            performRequestPassenger(parametrs: parametrs)
        }
    }
    func performRequestPassenger(parametrs: String) {
        if let url = URL(string: K.URLs.insertPassengerURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let hashedToken = SHA256.hash(data: Data(K.token.utf8)).description.replacingOccurrences(of: "SHA256 digest: ", with: "")
            let body = parametrs + "&token=\(hashedToken)"
            let finalBody = body.data(using: .utf8)
            request.httpBody = finalBody
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    self.delegate?.showErrorMessage(message: "Failed to load data.")
                }else {
                    if let data = data {
                        self.parseJSONPassenger(data: data)
                    }
                }
            }.resume()
        }
    }
    
    func parseJSONPassenger(data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Answer.self, from: data)
            if let answer = decodedData.answer {
                if answer == 1  {
                    delegate?.showSuccessMessage(message: "The account was successfully created.")
                }else if answer == 0 {
                    delegate?.showErrorMessage(message: "Failed to create an account. Try again later.")
                }else {
                    delegate?.showErrorMessage(message: "This login already exists.")
                }
            }else {
                delegate?.showErrorMessage(message: "Failed to get a response from the server.")
            }
        }catch {
            delegate?.showErrorMessage(message: "Failed to parse data.")
        }
    }
}

//MARK: - Country loading
extension RegistrationManager: CountryLoader {
    func downloadCountries() {
        let urlStr = K.URLs.loadCountriesURL
        performRequestCountry(urlS: urlStr)
    }
    
    func performRequestCountry(urlS: String) {
        if let url = URL(string: urlS) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let hashedToken = SHA256.hash(data: Data(K.token.utf8)).description.replacingOccurrences(of: "SHA256 digest: ", with: "")
            let body = "token=\(hashedToken)"
            let finalBody = body.data(using: .utf8)
            request.httpBody = finalBody
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    self.delegate?.showErrorMessage(message: "Failed to load data.")
                }else {
                    if let data = data {
                        self.parseJSONCountry(data: data)
                    }
                }
            }.resume()
        }
    }
    
    func parseJSONCountry(data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([Country].self, from: data)
            
            for c in decodedData {
                if let name = c.countryName, let id = c.ID {
                    pickerData.append(name)
                    countries[name] = id
                }
            }
            selectedCountry = decodedData[0].ID
            delegate?.updateCountryPickerView()
        }catch {
            delegate?.showErrorMessage(message: "Failed to parse data.")
        }
    }
}
