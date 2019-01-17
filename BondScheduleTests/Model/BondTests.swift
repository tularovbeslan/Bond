//
//  BondTests.swift
//  BondScheduleTests

import XCTest
@testable import BondSchedule

class BondTests: XCTestCase {

	var isin: String!
	var date: Int!
	var price: Double!
	var statisticType: StatisticType!
	var period: Period!
	var statistic: Statistic!

	override func setUp() {

		isin = "SP72EL7RYK6UN1G"
		date = 1547413200000
		price = 10.35
		statisticType = StatisticType(date: date, price: price)
		period = Period(price: [statisticType], yield: [statisticType])
		statistic = Statistic(week: period,
													oneMonth: period,
													threeMonth: period,
													sixMonth: period,
													oneYear: period,
													twoYear: period)
	}

	override func tearDown() {

		isin = nil
		date = nil
		price = nil
		statisticType = nil
		period = nil
	}

	func testInitBondWithIsin() {

		let bond = Bond(isin: isin, stat: statistic)
		XCTAssertNotNil(bond)
	}

	func testInitStatisticWithDecoder() {

		let json = """
        {"ISIN": "SP72EL7RYK6UN1G",
        "STAT": {
        "W": {
        "price": [{
        "date":1547413200000,
        "price":10.35
        }],
        "yield": [{
        "date":1547413200000,
        "price":10.35
        }]
        }
        }
        }
        """.data(using: .utf8)!

		let bond = try! JSONDecoder().decode(Bond.self, from: json)
		XCTAssertEqual(bond.isin, isin)
		XCTAssertEqual(bond.stat!.week!.yield!.first!.price, statisticType.price)
	}
}

