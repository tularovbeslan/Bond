import Foundation

public class Construction {

	public static func shares() -> [Double] {

		var result: [Double] = []
		for _ in 0..<1000 {
			let decimal = Double.random(lower: -1000, 1000)
			result.append(decimal)
		}
		return result
	}
}

public extension Double {

	public static func random(lower: Double = 0, _ upper: Double = 100) -> Double {
		return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
	}
}
