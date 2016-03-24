//
//  DataStore.swift
//  APShopper
//
//  Created by Abrar Peer on 23/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import Foundation


class DataStore: NSObject {
	
	
	var allMyShoppingLists = [ShoppingList]()
	
	var globalProducts = [String: [Product]]()
	
	var globalCategories = [Category]()
	
	class var sharedInstance: DataStore {
		
		log.debug("Started!")
		
		struct Singleton {
			
			static let instance = DataStore()
			
		}
		
		log.debug("Finished!")
		
		return Singleton.instance
		
	}
	
	override init() {
		
		log.debug("Started!")
		
		let bakeryCat = Category(name: "Bakery")
		let confectioneryCat = Category(name: "Confectionery")
		let dairyCat = Category(name: "Dairy")
		let freshProduceCat = Category(name: "Fresh Produce")
		let householdCat = Category(name: "Household")
		let uncategorised = Category(name: "Uncategorised")
		
		globalCategories = [bakeryCat, confectioneryCat, dairyCat, freshProduceCat, householdCat, uncategorised]
		
		//globalProducts = [croissants, raisinToast, hotCrossBuns, chocolatebar, cherryRipe, cookies, milk, butter, cheese, apples, tomatoes, corriander, dishWash, toothpaste, soap]
		
		let firstShoppingList = ShoppingList(name: "First Sample ShoppingList")
		let secondShoppingList = ShoppingList(name: "Second Sample ShoppingList")
		let thirdShoppingList = ShoppingList(name: "Third Sample Shoppinglist")
		
		allMyShoppingLists = [firstShoppingList, secondShoppingList, thirdShoppingList]
		
		super.init()
		
		addProduct(Product(name: "Croissants", category: bakeryCat))
		addProduct(Product(name: "Raisin Toast", category: bakeryCat))
		addProduct(Product(name: "Hot Cross Buns", category:bakeryCat))
		
		addProduct(Product(name: "Cocolate Bar", category: confectioneryCat))
		addProduct(Product(name: "Cherry Ripe", category: confectioneryCat))
		addProduct(Product(name:"Cookies", category: confectioneryCat))
		
		addProduct(Product(name:"Milk", category: dairyCat))
		addProduct(Product(name: "Butter", category: dairyCat))
		addProduct(Product(name: "Cheese", category:dairyCat))
		
		addProduct(Product(name: "Apples", category:freshProduceCat))
		addProduct(Product(name: "Tomatoes", category: freshProduceCat))
		addProduct(Product(name: "Corriander", category: freshProduceCat))
		
		addProduct(Product(name: "Dishwash Liquid", category: householdCat))
		addProduct(Product(name: "Toothpaste", category: householdCat))
		addProduct(Product(name: "Soap", category:householdCat))
		
		for shoppingList in allMyShoppingLists {
			
			let randomNumberOfProducts = Int(arc4random_uniform(UInt32(globalProducts.count)) + 1)
			
			for _ in 1..<randomNumberOfProducts {
				
				let randomCategoryChoice = Int(arc4random_uniform(UInt32(globalProducts.count)))
				
				let randomCatProducts = Array(globalProducts.values)[randomCategoryChoice]
				
				let randomProductChoice = Int(arc4random_uniform(UInt32(randomCatProducts.count)))
				
				let randomProduct = randomCatProducts[randomProductChoice]

				shoppingList.addProduct(randomProduct)

			}

		}
		
		log.debug("Finished!")
		
	}
	
	
	
	//MARK: Products
	
//	func getAllProductsForShoppingList(shoppingList: ShoppingList) -> [Product]? {
//		
//		log.debug("Started!")
//		
//		
//		
//		log.debug("Finished!")
//		
//		return nil
//		
//	}
	
	func getAllProductsInCategory(category: Category) -> [Product]? {
		
		log.debug("Started!")
			
		log.debug("Finished!")
		
		return globalProducts[category.name]
		
	}
	
	func addProduct(product: Product) {
		
		log.debug("Started!")
		
		let categoryName = product.category.name
		
		guard let productsInSameCategory = globalProducts[categoryName] else {
			
			var productsInCategory = [Product]()
			
			productsInCategory.append(product)
			
			globalProducts[categoryName] = productsInCategory
			
			log.debug("Finished!")
			
			return
			
		}
		
		if !(productsInSameCategory.contains(product)) {
			
			var productsInCategory = globalProducts[categoryName]
			
			productsInCategory?.append(product)
			
			globalProducts[categoryName] = productsInCategory
			
		}
		
		

	}
	
	func removeProductFromShoppingList(product: Product, shoppingList: ShoppingList) {
		
		log.debug("Started!")
		
		//TODO: Implement
		
		log.debug("Finished!")
		
	}
	
	
	//MARK: Category
	
	func addCategory(category: Category) {
		
		log.debug("Started!")
		
		//TODO: Implement
		
		log.debug("Finished!")
		
	}
	
	func removeCategory(category: Category) {
		
		log.debug("Started!")
		
		//TODO: Implement
		
		log.debug("Finished!")
		
	}
	
	//MARK: Utility
	
	func doesProductExistInCategory(product: Product, category: Category) -> Bool {
		
		log.debug("Started!")
		
		//TODO: Implement
		
		log.debug("Finished!")
		
		return true
		
		
	}
	


}