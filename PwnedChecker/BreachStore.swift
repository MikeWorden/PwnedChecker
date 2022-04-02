//
//  BreachStore.swift
//  PwnedChecker
//
//  Created by Michael Worden on 4/1/22.
//

import Foundation

class BreachStore {
	private let session:  URLSession = {
		var apiKey: String {
		  get {
			// 1
			guard let filePath = Bundle.main.path(forResource: "PwnedChecker-Info", ofType: "plist") else {
			  fatalError("Couldn't find file 'PwnedChecker-Info.plist'.")
			}
			// 2
			let plist = NSDictionary(contentsOfFile: filePath)
		
			guard let value = plist?.object(forKey: "API_KEY") as? String else {
			  fatalError("Couldn't find key 'API_KEY' in 'PwnedChecker-Info.plist'.")
			}
			return value
		  }
		}
		let config = URLSessionConfiguration.default
		config.httpAdditionalHeaders = ["User-Agent": "PwnedCHecker (iOS; 15)"]
		config.httpAdditionalHeaders = ["hibp-api-key" : apiKey]
		return URLSession(configuration: config)
	}()
	
	
	private func processBreachRequest(data: Data?,
									  error: Error?) -> Result<[Breach], Error> {
		guard let jsonData = data else {
			return .failure(error!)
		}
		
		return HIBPdAPI.breaches(fromJSON: jsonData)
	}

	
	
	func fetchAccountBreachInfo() {
		let url = HIBPdAPI.accountBreachURL(emailAccount: "wordenm@icloud.com")
		let request = URLRequest(url: url)
		
		let task = session.dataTask(with: request) {
			(data, response, error) in
			let _ = self.processBreachRequest(data: data, error: error)
			
		}
		task.resume()
	}
}
