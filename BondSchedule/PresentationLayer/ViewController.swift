//
//  ViewController.swift
//  BondSchedule
//
//  Created by workmachine on 13/01/2019.
//  Copyright © 2019 Beslan Tularov Ramazanovich. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let network = NetworkImp()
		let service = BondServiceImp()
		service.network = network
		let chart = ChartView(isin: "SP72EL7RYK6UN1G", service: service)
		view = chart
	}
}

