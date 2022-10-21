//
//  BookingTests.swift
//  LoginTests
//
//  Created by Alex on 03/06/2022.
//

import XCTest
@testable import buyTickets

class BookingTests: XCTestCase {
    var sut: BookingManager!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = BookingManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testPerformSegueAcceptance() throws {
        //given
        sut.selectedField = K.ListType.Departure
        //when
        var accept = sut.canPerformSegue(destText: "", depText: "")
        //then
        XCTAssertEqual(accept, true, "1.Segue could be performed")
        
        //given
        sut.selectedField = K.ListType.Destination
        //when
        accept = sut.canPerformSegue(destText: "", depText: "")
        //then
        XCTAssertEqual(accept, false, "2.Segue couldn't be performed")
        
        //given
        sut.selectedField = K.ListType.Destination
        //when
        accept = sut.canPerformSegue(destText: "", depText: "gbhny")
        //then
        XCTAssertEqual(accept, true, "3.Segue could be performed")
        
        //given
        sut.selectedField = K.ListType.Dates
        //when
        accept = sut.canPerformSegue(destText: "", depText: "fghyj")
        //then
        XCTAssertEqual(accept, false, "4.Segue couldn't be performed")
        
        //given
        sut.selectedField = K.ListType.Dates
        //when
        accept = sut.canPerformSegue(destText: "", depText: "")
        //then
        XCTAssertEqual(accept, false, "5.Segue couldn't be performed")
        
        //given
        sut.selectedField = K.ListType.Dates
        //when
        accept = sut.canPerformSegue(destText: "frgth", depText: "gtvbhyj")
        //then
        XCTAssertEqual(accept, true, "6.Segue could be performed")
    }
    
    func testFillAvailableSeats() {
        //given
        let seatsArr = [1,2,3,4,5,6,7,8,9,10,11,12,34,45,56,78]
        var seats = Seats()
        seats.seats = seatsArr
        let jsonEncoder = JSONEncoder()
        var jsonData: Data = Data()
        do {
            jsonData = try jsonEncoder.encode(seats)
        }catch {
            
        }
        //when
        sut.parseJSON(data: jsonData)
        //then
        XCTAssertEqual(sut.availableSeats, [1,2,3,4,5,6,7,8,9,10,11,12,34,45,56,78], "Wrong available seats array")
        XCTAssertEqual(sut.selectedSeat, sut.availableSeats![0], "Wrong set of selected seat")
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
