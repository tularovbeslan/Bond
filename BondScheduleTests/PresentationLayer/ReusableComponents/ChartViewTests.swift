//
//  ChartViewTests.swift
//  BondScheduleTests
//
//  Created by workmachine on 16/01/2019.
//  Copyright © 2019 Beslan Tularov Ramazanovich. All rights reserved.
//

import XCTest
@testable import BondSchedule

class ChartViewTests: XCTestCase {

	var isin: String!
	var service: BondServiceImp!
	var network: Network!
	var sut: ChartView!

	override func setUp() {

		network = NetworkImp()
		service = BondServiceImp()
		service.network = network
		isin = "SP72EL7RYK6UN1G"
		sut = ChartView(isin: isin, service: service)
	}

	override func tearDown() {

		isin = nil
		service = nil
		sut = nil
	}

	

	func testInitWithCoder() {

		let chartView = ChartView(coder: NSCoder())
		XCTAssertNil(chartView)
	}

	func testSetScale() {

		let scaleX: CGFloat = 5
		let scaleY: CGFloat = 5
		sut.setScale(scaleX, scaleY: scaleY)
		XCTAssertEqual(sut.chart.scaleX, scaleX)
		XCTAssertEqual(sut.chart.scaleY, scaleY)
	}

	func testPeriodChanged() {

		let button = UIButton(type: .custom)
		button.tag = 0
		guard let period = ChartView.PeriodType(rawValue: button.tag) else {
			XCTFail()
			return
		}
		XCTAssertEqual(sut.period, period)
	}

	func testStatistecParameterChanged() {

		let segmentedControl = UISegmentedControl(items: ["Price", "Yield"])
		segmentedControl.selectedSegmentIndex = 1
		let statistic = Statistic(week: nil, oneMonth: nil, threeMonth: nil, sixMonth: nil, oneYear: nil, twoYear: nil)
		sut.statistic = statistic
		sut.statisticParameterDidChange(segmentedControl)
		XCTAssertNotEqual(sut.parameter, ChartView.ParameterType.price)
	}

	func testSetSelectedButtonColor() {

		sut.setSelectedColorAt(0)
		guard let button = sut.buttons.first else {
			XCTFail()
			return
		}

		let color: UIColor = .blue
		let font: UIFont = UIFont.boldSystemFont(ofSize: 20)
		let title = NSAttributedString(string: button.titleLabel?.text ?? "", attributes: [.font : font, .foregroundColor : color])

		XCTAssertEqual(button.attributedTitle(for: .selected), title)
	}
}
