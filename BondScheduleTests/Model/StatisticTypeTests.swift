//
//  StatisticTypeTests.swift
//  BondScheduleTests

import XCTest
@testable import BondSchedule

class StatisticTypeTests: XCTestCase {

	var date: Int!
	var price: Double!

	override func setUp() {

		date = 1547413200000
		price = 7.54
	}

	override func tearDown() {

		date = nil
		price = nil
	}

	func testInitStatistic() {

		let statisticType = StatisticType(date: date, price: price)
		XCTAssertNotNil(statisticType)
	}

	func testInitStatisticTypeWithDecoder() {

		let json = """
        {
        "date": 1547413200000,
        "price": 10.35
        }
        """.data(using: .utf8)!

		let statisticType = try! JSONDecoder().decode(StatisticType.self, from: json)
		XCTAssertEqual(statisticType.price, 10.35)
		XCTAssertEqual(statisticType.date, 1547413200000)
	}
}
