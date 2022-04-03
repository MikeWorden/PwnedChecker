//
//  HIBPAPI.swift
//  PwnedChecker
//
//  Created by Michael Worden on 4/1/22.
//

import Foundation
import CloudKit

enum EndPoint:   String {
	case accountBreach = "breachedaccount"
	case systemBreach = "breaches"
	
	
}


struct HIBPdAPI {
	private static let baseURLString = "https://haveibeenpwned.com/api/v3/"
	
	
	private static func HIBPdURL(endPoint: EndPoint, account:  String,
									 parameters: [String:String]?) -> URL {
		let endpointString = baseURLString + endPoint.rawValue
		
		let fullURLString = endpointString + "/" + account
		var components = URLComponents(string: fullURLString)!
		var queryItems = [URLQueryItem]()
		
		
/*		var baseParams = [:] as NSDictionary
		
		for (key, value) in baseParams {
			let item = URLQueryItem(name: key, value: value)
			queryItems.append(item)
		}*/
		
		if let additionalParams = parameters {
			for (key, value) in additionalParams {
				let item = URLQueryItem(name: key, value: value)
				queryItems.append(item)
			}
		}
		components.queryItems = queryItems
		
		return components.url!
					   
	}
	/*static var accountBreachURL: URL {
		return HIBPdURL(endPoint: .accountBreach,
						parameters: ["truncateResponse":"false"])
	}*/
	static func accountBreachURL(emailAccount: String) -> URL {
		return HIBPdURL(endPoint: .accountBreach, account: emailAccount, parameters: ["truncateResponse":"false"])
	}
	
	
	struct HIBPResponse: Codable {
		let breaches: [Breach]
	}

	
	static func breaches(fromJSON data: Data) -> Result<[Breach], Error> {

		
		do {
			let decoder = JSONDecoder()
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			dateFormatter.locale = Locale(identifier: "en_US_POSIX")
			dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
			//decoder.dateDecodingStrategy = .formatted(dateFormatter)
			decoder.dateDecodingStrategy = .custom { decoder in
				let container = try decoder.singleValueContainer()
				let dateString = try container.decode(String.self)
				
				dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
				if let date = dateFormatter.date(from: dateString) {
					return date
				}
				dateFormatter.dateFormat = "yyyy-MM-dd"
				if let date = dateFormatter.date(from: dateString) {
					return date
				}
				throw DecodingError.dataCorruptedError(in: container,
													   debugDescription: "Cannot decode date string \(dateString)")
			}
			// Debug print for analyzing JSON returns
			/*if let jsonString = String(data: data,
									   encoding: .utf8) {
				print(jsonString)
			}*/
			let breaches = try decoder.decode([Breach].self, from: data)
			print(breaches.count)
			return .success(breaches)
			
			

		} catch {
			print("Error parsing json \(error)")
			return .failure(error)
		
		}
		
	}
	
}






