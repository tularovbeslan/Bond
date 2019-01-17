//
//  Network.swift
//  BondSchedule

import Foundation
import  Alamofire

typealias DataCompletion = (Data?, Error?) -> ()
typealias JSONCompletion = (Any?, Error?) -> ()
typealias ObjectCompletion<T> = (T?, Error?) -> ()

enum Encoding {
	case json
	case url
}

protocol Network {

	func requestData(
		_ url: URL,
		method: HTTPMethod,
		parameters: [String : Any]?,
		headers: [String : String]?,
		encoding: Encoding,
		completion: @escaping DataCompletion
	)

	func requestJSON(
		_ url: URL,
		method: HTTPMethod,
		parameters: [String : Any]?,
		headers: [String : String]?,
		encoding: Encoding,
		completion: @escaping JSONCompletion
	)

	func requestObject<T: Decodable>(
		_ url: URL,
		method: HTTPMethod,
		parameters: [String : Any]?,
		headers: [String : String]?,
		encoding: Encoding,
		objectType: T.Type,
		completion: @escaping ObjectCompletion<T>
	)
}
