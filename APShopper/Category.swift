//
//  Category.swift
//  APShopper
//
//  Created by Abrar Peer on 22/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import Foundation

class Category: Equatable {
	
	var name: String = ""
	var categorisedProducts: [Product?] = [];
	
	init(name: String) {
		
		self.name = name
		self.categorisedProducts = [Product]()
		
	}
	
	func addProduct(product: Product) {
		
		self.categorisedProducts.append(product)
		
	}
	
}

func == (lhs: Category, rhs: Category) -> Bool {
	return lhs.name == rhs.name
}

