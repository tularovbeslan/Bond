
import Foundation

/// Counting the amount of all deposits
///
/// Use this method to indicate the accuracy of a number
///
///		let shares: [Double] = [1.5, 3, 6, 1.5]
///		let result = sumOf(shares)
///
/// Complexity O(n) Memory M(1)
///
/// - Parameter shares: Shares of all investors
/// - Returns: Sum of all shares

func sumOf(_ shares: [Double]) -> Double {

	let sum = shares.reduce(0, +)
	return sum
}

/// Formatting output with the necessary precision
///
/// - Parameters:
///   - decimal: Input value
///   - format: Format for determining accuracy
///
/// Use this method to indicate the accuracy of a number
///
///		let number: Double = 5
///		let result = formatter(number, format: "0.000")
///
/// - Returns: Determining string of a number with a given precision

func formatter(_ decimal: Double, format: String) -> String {

	let formatter = NumberFormatter()
	formatter.numberStyle = .decimal
	formatter.positiveFormat = format
	formatter.roundingMode = NumberFormatter.RoundingMode.floor
	return formatter.string(for: decimal) ?? ""
}

/// Returns a list of each share of investors in percent
///
/// Use this method to get the percentage of each investor of his share.
///
///		let shares: [Double] = [1.5, 3, 6, 1.5]
///		let result = percentageOf(shares)
///
/// Complexity O(n^2) Memory M(n)
///
/// - Parameter shares: Shares of all investors
/// - Returns: An array of each investors share in percentage

func percentageOf(_ shares: [Double]) -> [String] {

	if shares.count > 1000 {
		return []
	}

	var result: [String] = []
	let sum = sumOf(shares)

	shares.forEach { (share) in
		let sharePercentage = (share / sum) * 100
		let percentage = formatter(sharePercentage, format: "0.000")
		result.append(percentage)
	}
	return result
}

print(percentageOf(Construction.shares()))

