//
//  StatisticTests.swift
//  BondScheduleTests

import XCTest
@testable import BondSchedule

class StatisticTests: XCTestCase {

	var date: Int!
	var price: Double!
	var statisticType: StatisticType!
	var period: Period!

	override func setUp() {

		date = 1547413200000
		price = 10.35
		statisticType = StatisticType(date: date, price: price)
		period = Period(price: [statisticType], yield: [statisticType])

	}

	override func tearDown() {

		date = nil
		price = nil
		statisticType = nil
		period = nil
	}

	func testInitStatistic() {

		let statistic = Statistic(week: period,
															oneMonth: period,
															threeMonth: period,
															sixMonth: period,
															oneYear: period,
															twoYear: period)
		XCTAssertNotNil(statistic)
	}

	func testInitStatisticWithDecoder() {

		let json = """
        {
        "W":{
        "price":[
        {
        "date":1547413200000,
        "price":10.35
        }
        ],
        "yield":[
        {
        "date":1547413200000,
        "price":10.35
        }
        ]
        }
        }
        """.data(using: .utf8)!

		let statistic = try! JSONDecoder().decode(Statistic.self, from: json)
		XCTAssertEqual(statistic.week!.price!.first!.date, statisticType.date)
		XCTAssertEqual(statistic.week!.yield!.first!.price, statisticType.price)
	}
}
