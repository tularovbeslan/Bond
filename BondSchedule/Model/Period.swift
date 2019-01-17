//
//  Period.swift
//  BondSchedule

import Foundation

struct Period: Codable {

	let price: [StatisticType]?
	let yield: [StatisticType]?

	enum CodingKeys: String, CodingKey {
		case price
		case yield
	}

	init(price: [StatisticType]? = nil, yield: [StatisticType]? = nil) {
		self.price = price
		self.yield = yield
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		self.price = try? values.decode([StatisticType].self, forKey: .price)
		self.yield = try? values.decode([StatisticType].self, forKey: .yield)
	}
}
