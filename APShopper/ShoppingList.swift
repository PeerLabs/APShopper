//
//  ShoppingList.swift
//  APShopper
//
//  Created by Abrar Peer on 22/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import Foundation

class ShoppingList : CustomStringConvertible {

	var name: String
	
	var products: [String: [Product]]
	
	var categoryList: [String]? {
		
		
		get {
			
			guard products.keys.count > 0 else {
				
				return nil
				
			}
			
			var categoryListName = [String]()
			
			for key in products.keys {
				
				if !categoryListName.contains(key) {
					
					categoryListName.append(key)
					
				}

			}
			
			return categoryListName
			
		}
		
	}
	

	
	var totalNumberOfProductsInList : Int {
		
		get {
			
			guard let allCategories = categoryList else {
				
				return 0
				
			}
			
			guard allCategories.count > 0 else {
				
				return 0
				
			}
			
			var totalNumberOfProducts = 0
			
			for categoryName in allCategories {
				
				totalNumberOfProducts += self.totalNumberOfProductsInCategoryWithName(categoryName)
				
			}
			
			return totalNumberOfProducts
			
		}
		
	}
	
	var description : String {
		
		get {
			
			
			guard let allCategories = categoryList else {
				
				return "Shopping List\n\tname: \(name)\n\tHas 0 Products in 0 Categories"
				
			}
			
			guard allCategories.count > 0 else {
				
				return "Shopping List\n\tname: \(name)\n\tHas 0 Products in 0 Categories"
				
			}
			
			var listOfCategoriesText : String {
				
				var outputText = ""
				
				for categoryName in allCategories {
					
					outputText = outputText + "\n\t\t - " + categoryName
					
				}
				
				return outputText
				
			}
			
			var listOfProductsText : String {
				
				var outputText = ""
			
				for categoryName in allCategories {
					
					guard let productsInCategory = products[categoryName] else {
						
						continue
						
					}
					
					guard productsInCategory.count < 0 else {
						
						continue
						
					}
					
					for product in productsInCategory {
					
						outputText = outputText + "\n\t\t - " + product.name
						
					}
					
					
				}
				
				return outputText
				
			}
			
			
			return "Shopping List\n\tname: \(name)\n\tNumber Of Products: \(totalNumberOfProductsInList)\n\tList Of Products:\(listOfProductsText)\n\tList Of Unique Categories:\(listOfCategoriesText)"
			
		}
		
	}
	
	init(name: String) {
		
		self.name = name
		self.products = [String: [Product]]()
				
	}
	
	func addProduct(product: Product) {
		
		log.debug("Started!")

		if !doesProductExistInShoppingList(product) {
			
			let categoryName = product.category.name
			
			guard products.keys.contains(categoryName) else {
				
				var newProductsInNewCategory = [Product]()
				newProductsInNewCategory.append(product)
				
				products[categoryName] = newProductsInNewCategory
				
				log.debug("Finished!")
				
				return
				
			}
			
			var productsInCategory = products[categoryName]
			
			productsInCategory?.append(product)
			
			products[categoryName] = productsInCategory!
			
			log.debug("Finished!")
			
		}
		
		log.debug("Finished!")
				
	}
	
	func productsForCategory(category: Category) -> [Product]? {
		
		log.debug("Started!")
		
		if products.isEmpty {
			
			log.debug("Finished!")
			
			return nil
			
		} else {
			
			
			guard let productsInCategory = products[category.name] else {
				
				log.debug("Finished!")
				
				return nil
				
			}
			
			log.debug("Finished!")
			
			return productsInCategory
			
		}

	}
	
	func doesProductExistInShoppingList(product: Product) -> Bool {
		
		log.debug("Started!")
		
		if products.keys.contains(product.category.name) {
			
			guard let productsInCategory = products[product.category.name] else {
				
				log.debug("Finished!")
				
				return false
				
			}
			
			guard productsInCategory.count > 0 else {
				
				log.debug("Finished!")
				
				return false
				
			}
			
			if productsInCategory.contains(product) {
				
				log.debug("Finished!")
				
				return true
				
			} else {
				
				log.debug("Finished!")
				
				return false
				
			}
			
		} else {
			
			log.debug("Finished!")
			
			return false
			
		}

	}
	
	
	func totalNumberOfProductsInCategoryWithName(categoryName: String) -> Int {
		
		log.debug("Started!")
		
		guard categoryList != nil else {
			
			log.debug("Finished!")
			
			return 0
			
		}
		
		guard categoryList?.count > 0 else {
			
			log.debug("Finished!")
			
			return 0
		}
		
		guard products.keys.contains(categoryName) else {
			
			log.debug("Finished!")
			
			return 0
			
		}
		
		guard let productsInCategory = products[categoryName] else {
			
			log.debug("Finished!")
			
			return 0
			
		}
		
		log.debug("Finished!")
		
		return productsInCategory.count

		
	}

	
}