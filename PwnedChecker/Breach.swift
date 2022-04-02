//
//  Breach.swift
//  PwnedChecker
//
//  Created by Michael Worden on 4/2/22.
//

import Foundation

class Breach: Codable {
	
	let name:  String
	let title: String
	let domain: String
	let breachDate: Date
	let modifiedDate: Date
	let pwnCount: Int64
	let description: String
	/*
	let verified: String
	let isFabricated: Bool
	let isSensitive: Bool
	let isRetired: Bool
	let isSpamList: Bool
	let isMalware: Bool*/
	
	enum CodingKeys: String, CodingKey {
		case name = "Name"
		case title = "Title"
		case domain = "Domain"
		case breachDate = "BreachDate"
		case modifiedDate = "ModifiedDate"
		case pwnCount = "PwnCount"
		case description = "Description"
		/*case isVerified = "IsVerified"
		case isSensitive = "IsSensitive"
		case isRetired = "IsRetired"
		case isSpamList = "IsSpamList"
		case isMalware = "IsMalware"*/
	
	}
}
