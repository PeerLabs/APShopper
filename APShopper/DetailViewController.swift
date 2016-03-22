//
//  DetailViewController.swift
//  APShopper
//
//  Created by Abrar Peer on 22/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var detailDescriptionLabel: UILabel!


	var detailItem: ShoppingList? {
		didSet {
		    // Update the view.
		    self.configureView()
		}
	}

	func configureView() {
		
		log.debug("Started!")
		
		// Update the user interface for the detail item.
		if let detail = self.detailItem {
		    if let label = self.detailDescriptionLabel {
		        label.text = detail.name
		    }
		}
		
		log.debug("Finished!")
		
	}

	override func viewDidLoad() {
		
		log.debug("Started!")
		
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.configureView()
		
		log.debug("Finished!")
		
	}

	override func didReceiveMemoryWarning() {
		
		log.debug("Started!")
		
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
		log.debug("Finished!")
		
	}


}

