//
//  BondServiceImp.swift
//  BondSchedule
//
//  Created by workmachine on 14/01/2019.
//  Copyright © 2019 Beslan Tularov Ramazanovich. All rights reserved.
//

import Foundation

class BondServiceImp: BondService {

	var network: Network!

	func fetchBondStatistic(completion: @escaping ([Bond]?, Error?) -> ()) {
		guard let url = URL(string: "https://gist.githubusercontent.com/tularovbeslan/75bb5236175c82bd6edd8103bc8aeea7/raw/fb904d07eb615a1b9e4fa0c35145b41f38f74ce0/TestStatInfo") else { return }
		network.requestObject(url, method: .get, parameters: nil, headers: nil, encoding: .json, objectType: [Bond].self) { (object, error) in
			completion(object, error)
		}
	}
}
