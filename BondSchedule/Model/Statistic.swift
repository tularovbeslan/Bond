//
//  Statistic.swift
//  BondSchedule

import Foundation

struct Statistic: Codable {

	let week: Period?
	let oneMonth: Period?
	let threeMonth: Period?
	let sixMonth: Period?
	let oneYear: Period?
	let twoYear: Period?

	enum CodingKeys: String, CodingKey {

		case week 		= "W"
		case oneMonth = "1M"
		case threeMonth = "3M"
		case sixMonth = "6M"
		case oneYear 	= "1Y"
		case twoYear 	= "2Y"
	}

	init(week: Period? = nil,
			 oneMonth: Period? = nil,
			 threeMonth: Period? = nil,
			 sixMonth: Period? = nil,
			 oneYear: Period? = nil,
			 twoYear: Period? = nil) {

		self.week = week
		self.oneMonth = oneMonth
		self.threeMonth = threeMonth
		self.sixMonth = sixMonth
		self.oneYear = oneYear
		self.twoYear = twoYear
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		self.week = try? values.decode(Period.self, forKey: .week)
		self.oneMonth = try? values.decode(Period.self, forKey: .oneMonth)
		self.threeMonth = try? values.decode(Period.self, forKey: .threeMonth)
		self.sixMonth = try? values.decode(Period.self, forKey: .sixMonth)
		self.oneYear = try? values.decode(Period.self, forKey: .oneYear)
		self.twoYear = try? values.decode(Period.self, forKey: .twoYear)
	}
}
