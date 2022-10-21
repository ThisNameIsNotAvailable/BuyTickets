//
//  LoginTests.swift
//  LoginTests
//
//  Created by Alexey Valevich on 06/05/2022.
//

import XCTest
@testable import buyTickets



class LoginTests: XCTestCase {
    var sut: LoginManager!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = LoginManager()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    func testCheckReturnPassengerID() {
        for _ in 1...100 {
            //given
            let randomID = Int.random(in: 1...1000)
            let passenger = Passenger(passengerID: randomID, firstName: "Test", lastName: "Test", login: "login", password: "password", countryID: 2)
            let jsonEncoder = JSONEncoder()
            var jsonData: Data = Data()
            do {
                jsonData = try jsonEncoder.encode(passenger)
            }catch {
                
            }
            
            //when
            let id = sut.parseJSON(data: jsonData)
            
            //then
            XCTAssertEqual(id, randomID, "Return wrong passenger ID")
            XCTAssertEqual(sut.passengerID, randomID, "Return wrong passenger ID")
        }
    }

}
