//
//  RegistrationTests.swift
//  LoginTests
//
//  Created by Alexey Valevich on 06/05/2022.
//

import XCTest
@testable import buyTickets

class RegistrationTests: XCTestCase {
    var sut: RegistrationManager!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = RegistrationManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func testSetSelectedCountry() {
        //given
        sut.countries = [
            "Poland" : 1,
            "UK" : 2,
            "France" : 3,
            "India" : 4,
            "Italy" : 5,
            "Latvia" : 6,
            "Germany" : 7
        ]
        for _ in 1...100 {
            //given
            let country = sut.countries.keys.randomElement()
            //when
            sut.setSelectedCountry(to:"\(country!)")
            
            //then
            XCTAssertEqual(sut.selectedCountry, sut.countries[country!], "Incorrect setting selected country")
        }
    }
    
    func testFillPickerData() {
        //given
        let countries = [
            Country(ID: 1, countryName: "Poland"),
            Country(ID: 2, countryName: "UK"),
            Country(ID: 3, countryName: "France"),
            Country(ID: 4, countryName: "India"),
            Country(ID: 5, countryName: "Italy"),
            Country(ID: 6, countryName: "Latvia"),
            Country(ID: 7, countryName: "Germany")
        ]
        let jsonEncoder = JSONEncoder()
        var jsonData: Data = Data()
        do {
            jsonData = try jsonEncoder.encode(countries)
        }catch {
            
        }
        //when
        sut.parseJSONCountry(data: jsonData)
        //then
        XCTAssertEqual(sut.pickerData, ["Poland","UK","France","India","Italy","Latvia","Germany"], "Error in reading data to picker data")
    }
    
    func testFillCountries() {
        //given
        let countries = [
            Country(ID: 1, countryName: "Poland"),
            Country(ID: 2, countryName: "UK"),
            Country(ID: 3, countryName: "France"),
            Country(ID: 4, countryName: "India"),
            Country(ID: 5, countryName: "Italy"),
            Country(ID: 6, countryName: "Latvia"),
            Country(ID: 7, countryName: "Germany")
        ]
        let jsonEncoder = JSONEncoder()
        var jsonData: Data = Data()
        do {
            jsonData = try jsonEncoder.encode(countries)
        }catch {
            
        }
        //when
        sut.parseJSONCountry(data: jsonData)
        //then
        XCTAssertEqual(sut.countries, ["Poland" : 1,"UK": 2,"France": 3,"India": 4,"Italy": 5,"Latvia": 6,"Germany": 7], "Error in reading data to picker data")
    }
    
    

}
