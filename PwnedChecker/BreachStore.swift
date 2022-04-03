//
//  BreachStore.swift
//  PwnedChecker
//
//  Created by Michael Worden on 4/1/22.
//

import Foundation
import UIKit

class BreachStore {
	
	var breaches: [Breach] = []
	var addressToCheck: String = ""
	
	private let session:  URLSession = {
		var apiKey: String {
		  get {
			
			guard let filePath = Bundle.main.path(forResource: "PwnedChecker-Info", ofType: "plist") else {
			  fatalError("Couldn't find file 'PwnedChecker-Info.plist'.")
			}
			
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

	
	
	func fetchAccountBreachInfodata(completion: @escaping (Result<[Breach], Error>) -> Void){
		let url = HIBPdAPI.accountBreachURL(emailAccount: self.addressToCheck)
		let request = URLRequest(url: url)
		
		let task = session.dataTask(with: request) {
			(data, response, error) in
			let result = self.processBreachRequest(data: data, error: error)
			OperationQueue.main.addOperation {
				completion(result)
			}
		}
		task.resume()
	}
	
	
	func isValidEmail() -> Bool {
		
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: self.addressToCheck)
	}
}
