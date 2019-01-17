//
//  BondService.swift
//  BondSchedule
//
//  Created by workmachine on 14/01/2019.
//  Copyright © 2019 Beslan Tularov Ramazanovich. All rights reserved.
//

import Foundation

protocol BondService {
	func fetchBondStatistic(completion: @escaping ([Bond]?, Error?) -> ())
}
