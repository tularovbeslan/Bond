//
//  StatisticType.swift
//  BondSchedule

import Foundation

struct StatisticType: Codable {
	
	let date: Int?
	let price: Double?

	enum CodingKeys: String, CodingKey {
		case date
		case price
	}

	init(date: Int? = nil, price: Double? = nil) {
		self.date = date
		self.price = price
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		self.date = try? values.decode(Int.self, forKey: .date)
		self.price = try? values.decode(Double.self, forKey: .price)
	}
}
