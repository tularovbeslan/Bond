//
//  NetworkImp.swift
//  BondSchedule

import Foundation
import Alamofire
import CodableAlamofire

class NetworkImp: Network {

	private var requests = [DataRequest]()

	func requestData(_ url: URL, method: HTTPMethod, parameters: [String : Any]?, headers: [String : String]?, encoding: Encoding, completion: @escaping DataCompletion) {
		buildRequest(url: url, method, parameters, headers: headers, encoding: parameter(encoding)).response { (dataResponse) in
			completion(dataResponse.data, dataResponse.error)
		}
	}

	func requestJSON(_ url: URL, method: HTTPMethod, parameters: [String : Any]?, headers: [String : String]?, encoding: Encoding, completion: @escaping JSONCompletion) {
		buildRequest(url: url, method, parameters, headers: headers, encoding: parameter(encoding)).responseJSON { (jsonResponse) in
			if jsonResponse.result.isSuccess {
				completion(jsonResponse.result.value, nil)
			} else {
				completion(nil, jsonResponse.result.error)
			}
		}
	}

	func requestObject<T: Decodable>(_ url: URL, method: HTTPMethod, parameters: [String : Any]?, headers: [String : String]?, encoding: Encoding, objectType: T.Type, completion: @escaping ObjectCompletion<T>) {
		buildRequest(url: url, method, parameters, headers: headers, encoding: parameter(encoding))
			.responseDecodableObject { (response: DataResponse<T>) in
				if response.result.isSuccess {
					completion(response.result.value, nil)
				} else {
					completion(nil, response.result.error)
				}
		}
	}

	private func buildRequest(url: URL, _ method: HTTPMethod, _ params: Parameters?, headers: HTTPHeaders?, encoding: ParameterEncoding) -> DataRequest {
		let request = Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
		requests.append(request)
		return request
	}

	private func parameter(_ encoding: Encoding) -> ParameterEncoding {
		switch encoding {
		case .json:
			return JSONEncoding.default
		default:
			return URLEncoding.default
		}
	}
}
