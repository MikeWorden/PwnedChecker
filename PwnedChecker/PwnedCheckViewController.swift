//
//  ViewController.swift
//  PwnedChecker
//
//  Created by Michael Worden on 4/1/22.
//

import UIKit

class PwnedCheckViewController: UITableViewController {

	
	var store: BreachStore!
	
	
	
	@IBOutlet var messageLabel: UILabel!
	
	@IBOutlet var activityIndicatorView: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		store.fetchAccountBreachInfo()
	}

	override func tableView(_ tableView: UITableView,
								commit editingStyle: UITableViewCell.EditingStyle,
								forRowAt indexPath: IndexPath) {
	}
	
	override func tableView(_ tableView: UITableView,
							moveRowAt sourceIndexPath: IndexPath,
							to destinationIndexPath: IndexPath) {}
	
	override func tableView(_ tableView: UITableView,
				numberOfRowsInSection section: Int) -> Int {
		return 0
	}

}

