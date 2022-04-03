//
//  ViewController.swift
//  PwnedChecker
//
//  Created by Michael Worden on 4/1/22.
//

import UIKit

class PwnedCheckViewController: UIViewController,UITextFieldDelegate {
	
	
	
	
	var store: BreachStore!
	@IBOutlet weak var addressToCheck: UITextField!
	@IBOutlet weak var errorLabel: UILabel!
	
	
	
	@IBAction func checkAddress(_ sender: Any) {
			
		store = BreachStore()
		
		store.addressToCheck = addressToCheck.text!
		
		
		if store.isValidEmail() {
			store.fetchAccountBreachInfodata{
				(breachResult) in
				switch breachResult {
				case let .success(breaches):
					self.store.breaches = breaches
					print("There are \(breaches.count) breaches")
					
						
					for breach in self.store.breaches {
						print (breach.name)
					}
					if self.store.breaches.count > 0 {
						self.errorLabel.text = "You have been pwned \(self.store.breaches.count) times!"
						
					} else {
						self.errorLabel.text = "This account is safe"
					}
					self.errorLabel.textColor = UIColor.black
					self.errorLabel.isHidden = false
										
				case let .failure(error):
					print("Error retrieving results:  \(error)")
				}
			}
			
			
			print("Store has \(self.store.breaches.count) entries")
		} else {
			self.errorLabel.text = "Invalid Address!"
			self.errorLabel.textColor = UIColor.red
			self.errorLabel.isHidden = false
		}
		
		
	}
	
	@IBAction func addressChanged(_ sender: Any) {
		errorLabel.textColor = self.view.backgroundColor
		errorLabel.text = "Invalid Address!"
		
	}



	
	
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		
	}
	
	


}

