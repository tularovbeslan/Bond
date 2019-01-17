//
//  Bond.swift
//  BondSchedule

import Foundation

struct Bond: Codable {

	let isin: String?
	let stat: Statistic?

	enum CodingKeys: String, CodingKey {
		case isin = "ISIN"
		case stat = "STAT"
	}

	init(isin: String, stat: Statistic? = nil) {
		self.isin = isin
		self.stat = stat
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		self.isin = try? values.decode(String.self, forKey: .isin)
		self.stat = try? values.decode(Statistic.self, forKey: .stat)
	}
}
