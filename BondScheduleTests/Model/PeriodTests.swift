//
//  PeriodTests.swift
//  BondScheduleTests

import XCTest
@testable import BondSchedule

class PeriodTests: XCTestCase {

	var date: Int!
	var price: Double!
	var statisticType: StatisticType!

	override func setUp() {

		date = 1547413200000
		price = 10.35
		statisticType = StatisticType(date: date, price: price)
	}

	override func tearDown() {

		date = nil
		price = nil
		statisticType = nil
	}

	func testInitPeriod() {

		let period = Period(price: [statisticType], yield: [statisticType])
		XCTAssertNotNil(period)
	}

	func testInitPeriodWithDecoder() {

		let json = """
        {
        "price": [{
        "date":1547413200000,
        "price":10.35
        }],
        "yield": [{
        "date":1547413200000,
        "price":10.35
        }]
        }
        """.data(using: .utf8)!

		let period = try! JSONDecoder().decode(Period.self, from: json)
		XCTAssertEqual(period.price?.first!.date, statisticType.date)
		XCTAssertEqual(period.yield?.first!.price, statisticType.price)
	}
}
