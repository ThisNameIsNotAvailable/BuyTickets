//
//  MyTicketsTests.swift
//  LoginTests
//
//  Created by Alex on 03/06/2022.
//

import XCTest
@testable import buyTickets
class MyTicketsTests: XCTestCase {
    var sut: MyTicketsManager!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = MyTicketsManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        //given
        sut.selectedTicketType = K.TicketType.finished
        let tickets = [
            Ticket(start: "1", target: "2", numberOfSeat: 1, dateOfDeparture: "2020-01-23 11:00:00", canceled: true),
            Ticket(start: "2", target: "1", numberOfSeat: 15, dateOfDeparture: "2020-01-23 10:30:00", canceled: false),
            Ticket(start: "3", target: "2", numberOfSeat: 12, dateOfDeparture: "2020-01-23 10:00:00", canceled: true),
            Ticket(start: "2", target: "4", numberOfSeat: 11, dateOfDeparture: "2020-01-23 10:00:00", canceled: false),
            Ticket(start: "4", target: "1", numberOfSeat: 45, dateOfDeparture: "2020-01-23 14:00:00", canceled: false),
            Ticket(start: "5", target: "3", numberOfSeat: 32, dateOfDeparture: "2020-01-23 15:00:00", canceled: true),
        ]
        let expected = [
            Ticket(start: "2", target: "1", numberOfSeat: 15, dateOfDeparture: "2020-01-23 10:30:00", canceled: false),
            Ticket(start: "2", target: "4", numberOfSeat: 11, dateOfDeparture: "2020-01-23 10:00:00", canceled: false),
            Ticket(start: "4", target: "1", numberOfSeat: 45, dateOfDeparture: "2020-01-23 14:00:00", canceled: false)
        ]
        let jsonEncoder = JSONEncoder()
        var jsonData: Data = Data()
        do {
            jsonData = try jsonEncoder.encode(tickets)
        }catch {
            
        }
        
        //when
        sut.parseJSON(data: jsonData)
        
        //then
        XCTAssertEqual(sut.tickets, tickets, "Error in filling tickets array")
        XCTAssertEqual(sut.filteredData!, expected, "Error in copying tickets array")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
