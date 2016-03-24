//
//  Product.swift
//  APShopper
//
//  Created by Abrar Peer on 22/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import Foundation

class Product: Equatable, CustomStringConvertible {
	
	let name : String
	let category : Category
	
	var description : String {
		
		get {
			
			return "Product: \(name)"
			
		}
		
	}
	
	init(name: String) {
		
		self.name = name
		self.category = Category(name: "Uncategorised")

	}
	
	init(name: String, category : Category) {
		
		self.name = name
		self.category = category
		
	}


}

func == (lhs: Product, rhs: Product) -> Bool {
	
	return (lhs.name == rhs.name) //&& (lhs.category == rhs.category)
	
}
