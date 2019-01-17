//
//  ChartView.swift
//  BondSchedule
//
//  Created by workmachine on 14/01/2019.
//  Copyright © 2019 Beslan Tularov Ramazanovich. All rights reserved.
//

import UIKit
import Charts
import PinLayout
import FlexLayout

class ChartView: UIView {

	fileprivate var isin: String!
	fileprivate var service: BondService!
	fileprivate var rootFlexContainer: UIView!
	fileprivate var indicatorFlexContainer: UIView!
	var statistic: Statistic!
	var parameter: ParameterType = .price
	var period: PeriodType = .week
	fileprivate var times: [String] = []
	var buttons: [UIButton] = []
	lazy var chart: LineChartView = {

		let view = LineChartView()
		view.chartDescription?.enabled = false
		view.dragEnabled = true
		view.setScaleEnabled(true)
		view.pinchZoomEnabled = false
		view.scaleYEnabled = false
		view.rightAxis.enabled = false
		view.legend.form = .none
		view.xAxis.labelFont = .boldSystemFont(ofSize: 15)
		view.xAxis.labelTextColor = .black
		view.xAxis.labelPosition = .bottomInside
		view.xAxis.valueFormatter = self
		view.leftAxis.labelFont = .boldSystemFont(ofSize: 15)
		view.leftAxis.labelTextColor = .black
		view.leftAxis.labelPosition = .insideChart
		view.leftAxis.labelAlignment = .left
		return view
	}()

	let indicator: UIActivityIndicatorView = {

		let view = UIActivityIndicatorView(style: .gray)
		view.startAnimating()
		return view
	}()

	lazy var segmentControl: UISegmentedControl = {

		let view = UISegmentedControl(items: ["Price", "Yield"])
		view.selectedSegmentIndex = 0
		view.addTarget(self, action: #selector(statisticParameterDidChange), for: UIControl.Event.valueChanged)
		return view
	}()

	convenience init(isin: String, service: BondService) {
		self.init()
		self.service = service
		self.isin = isin
		fetchStatisticAt(isin)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = .white
		createPeriodButtons()
		rootFlexContainer = UIView()
		indicatorFlexContainer = UIView()
		addSubview(rootFlexContainer)
		setupFlexLayout()
	}

	required init?(coder aDecoder: NSCoder) {
		return nil
	}

	fileprivate func setupFlexLayout() {

		rootFlexContainer.flex.define { (container) in

			container
				.addItem(chart)
				.grow(1)
				.shrink(1)

			container.addItem()
				.height(40)
				.define({ (buttonsContainer) in

				for i in 0..<6 {
					buttonsContainer
						.direction(.row)
						.justifyContent(.spaceAround)
						.addItem(buttons[i])
						.grow(1)
				}
			})

			container.addItem(segmentControl).backgroundColor(.white)
				.justifyContent(.start)
				.position(.absolute)
				.width(140)
				.marginLeft(50)
				.marginTop(15)

			container.addItem(indicatorFlexContainer)
				.backgroundColor(.white)
				.justifyContent(.center)
				.position(.absolute)
				.size(UIScreen.main.bounds.size)
				.define({ (indicatorContainer) in

					indicatorContainer
						.addItem(indicator)
				})
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		rootFlexContainer.pin.all(pin.safeArea)
		rootFlexContainer.flex.layout()
	}

	// MARK: - Actions -

	@objc func periodDidPress(_ sender: UIButton) {

		let scaleX: CGFloat = CGFloat(sender.tag * sender.tag * 2)
		let scaleY: CGFloat = 0
		setScale(scaleX, scaleY: scaleY)
		setSelectedColorAt(sender.tag)
		guard let periodType = PeriodType(rawValue: sender.tag) else { return }
		period = periodType
		updateChartForPeriod(period, parameter: parameter)
	}

	@objc func statisticParameterDidChange(_ sender: UISegmentedControl) {
		parameter = sender.selectedSegmentIndex == 0 ? .price : .yield
		self.updateChartForPeriod(period, parameter: self.parameter)
	}

	func setScale(_ scaleX: CGFloat, scaleY: CGFloat) {
		chart.fitScreen()
		chart.setScaleMinima(scaleX, scaleY: scaleY)
	}

	func createPeriodButtons() {

		for i in 0..<6 {

			let button = UIButton()
			button.tag = i
			button.addTarget(self, action: #selector(periodDidPress), for: .touchUpInside)
			button.setTitleColor(.black, for: .normal)

			let isSelected = button.tag == 0
			let color: UIColor = isSelected ? .blue : .black
			let font: UIFont = UIFont.boldSystemFont(ofSize: 20)

			guard let text = PeriodType(rawValue: i)?.description else { return }

			let title = NSAttributedString(string: text, attributes: [.font : font, .foregroundColor : color])
			button.setAttributedTitle(title, for: .normal)

			buttons.append(button)
		}
	}

	func setSelectedColorAt(_ tag: Int) {

		buttons.forEach { (button) in

			let isSelected = button.tag == tag
			let color: UIColor = isSelected ? UIColor(red:10/255.0, green:96/255.0, blue:255/255.0, alpha: 1) : .black
			let font: UIFont = UIFont.boldSystemFont(ofSize: 20)
			let title = NSAttributedString(string: button.titleLabel?.text ?? "", attributes: [.font : font, .foregroundColor : color])
			button.setAttributedTitle(title, for: .normal)
		}
	}
 
	func updateChartForPeriod(_ type: PeriodType, parameter: ParameterType) {

		times.removeAll()

		var chartData: [ChartDataEntry] = []
		let period = takeStatisticForPeriod(type)
		guard let info = takeParameter(parameter, from: period) else { return }

		for item in info.enumerated() {
			guard let price = item.element.price else { return }
			guard let date = item.element.date else { return }
			times.append(dateFormatter(Double(date)))

			let data = ChartDataEntry(x: Double(item.offset), y: price)
			chartData.append(data)
		}

		let lineChartDataSet = LineChartDataSet(values: chartData, label: nil)
		lineChartDataSet.axisDependency = .left
		lineChartDataSet.setColor(UIColor(red:228/255.0, green:97/255.0, blue:119/255.0, alpha: 1))
		lineChartDataSet.lineWidth = 2
		lineChartDataSet.drawCircleHoleEnabled = false
		lineChartDataSet.drawCirclesEnabled = false

		let lineChartData = LineChartData(dataSets: [lineChartDataSet])
		lineChartData.setValueTextColor(.black)
		lineChartData.setValueFont(.boldSystemFont(ofSize: 15))

		chart.data = lineChartData
	}

	fileprivate func takeParameter(_ type: ParameterType, from period: Period?) -> [StatisticType]? {

		switch type {
		case .price: return period?.price
		case .yield: return period?.yield
		}
	}

	func takeStatisticForPeriod(_ type: PeriodType) -> Period? {

		switch type {
		case .week: return statistic.week
		case .oneMonth: return statistic.oneMonth
		case .threeMonth: return statistic.threeMonth
		case .sixMonth: return statistic.sixMonth
		case .oneYear: return statistic.oneYear
		case .twoYear: return statistic.twoYear
		}
	}

	fileprivate func fetchStatisticAt(_ isin: String?) {

		service.fetchBondStatistic { [weak self] (bonds, error) in

			guard let `self` = self else { return }
			self.indicatorFlexContainer.isHidden = true

			bonds?.forEach({ (bond) in
				if bond.isin == isin {
					self.statistic = bond.stat
					self.updateChartForPeriod(self.period, parameter: self.parameter)
				}
			})
		}
	}
}

extension ChartView: IAxisValueFormatter {

	public func stringForValue(_ value: Double, axis: AxisBase?) -> String {

		if Double(times.count) > value {
			return times[Int(value)]
		}

		return ""
	}
}

extension ChartView {
	fileprivate func dateFormatter(_ timestamp: Double) -> String {
		let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM"
		return dateFormatter.string(from: date)
	}
}

extension ChartView {

	enum ParameterType {

		case price
		case yield
	}

	enum PeriodType: Int {

		case week
		case oneMonth
		case threeMonth
		case sixMonth
		case oneYear
		case twoYear

		var description: String {

			switch self {
			case .week: return "W"
			case .oneMonth: return "1M"
			case .threeMonth: return "3M"
			case .sixMonth: return "6M"
			case .oneYear: return "1Y"
			case .twoYear: return "2Y"
			}
		}
	}
}
