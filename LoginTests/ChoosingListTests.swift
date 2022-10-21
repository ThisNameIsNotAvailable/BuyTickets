//
//  ChoosingListTests.swift
//  LoginTests
//
//  Created by Alex on 03/06/2022.
//

import XCTest
@testable import buyTickets

class ChoosingListTests: XCTestCase {
    var sut: ChoosingListManager!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = ChoosingListManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testFillAirportsAndFilteredData() throws {
        //given
        let airports = [
            Airport(ID: 1, Airport_name: "1", countryName: "1"),
            Airport(ID: 2, Airport_name: "2", countryName: "2"),
            Airport(ID: 3, Airport_name: "3", countryName: "3"),
            Airport(ID: 4, Airport_name: "4", countryName: "4"),
            Airport(ID: 5, Airport_name: "5", countryName: "5"),
            Airport(ID: 6, Airport_name: "6", countryName: "6"),
        ]
        let jsonEncoder = JSONEncoder()
        var jsonData: Data = Data()
        do {
            jsonData = try jsonEncoder.encode(airports)
        }catch {
            
        }
        
        //when
        sut.parseJSONAirport(data: jsonData)
        
        //then
        XCTAssertEqual(sut.airports, airports, "Error in filling airports array")
        XCTAssertEqual(sut.filteredData as! [Airport], airports, "Error in copying airports array")
        
    }
    
    func testFillRoutesAndFilteredData() throws {
        //given
        let routes = [
            Route(ID: 1, DateTimeOfDeparture: "1"),
            Route(ID: 2, DateTimeOfDeparture: "2"),
            Route(ID: 3, DateTimeOfDeparture: "3"),
            Route(ID: 4, DateTimeOfDeparture: "4"),
            Route(ID: 5, DateTimeOfDeparture: "5"),
            Route(ID: 6, DateTimeOfDeparture: "6"),
        ]
        let jsonEncoder = JSONEncoder()
        var jsonData: Data = Data()
        do {
            jsonData = try jsonEncoder.encode(routes)
        }catch {
            
        }
        
        //when
        sut.parseJSONDate(data: jsonData)
        
        //then
        XCTAssertEqual(sut.routes, routes, "Error in filling routes array")
        XCTAssertEqual(sut.filteredData as! [Route], routes, "Error in copying routes array")
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
