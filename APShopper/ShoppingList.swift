//
//  ShoppingList.swift
//  APShopper
//
//  Created by Abrar Peer on 22/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import Foundation

class ShoppingList {

	var name: String
	var products: [Product?]
	
	init(name: String) {
		
		self.name = name
		self.products = [Product?]()
				
	}

	
}