//
//  ShoppingListViewController.swift
//  APShopper
//
//  Created by Abrar Peer on 22/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import UIKit

class ShoppingListViewController: UITableViewController, UISearchDisplayDelegate, GlobalProductsListTableViewControllerDelegate {
	
	let searchController = UISearchController(searchResultsController: nil)
	
	var shoppingList : ShoppingList? {
		
		didSet {
			
			guard shoppingList != nil else {
				
				return
				
			}
			
			log.debug(shoppingList?.description)
			
			self.tableView?.reloadData()
			
		}
		
	}
	
	var filteredProductsList = [Product]()
	
	override func viewDidLoad() {
		
		log.debug("Started!")
		
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		//self.configureView()
		
		//self.navigationItem.leftBarButtonItem = self.editButtonItem()
		
//		self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

		setupSearch()
		
		self.title = "Product List"
		self.navigationItem.prompt = shoppingList?.name
		
		registerNibs()
		
		log.debug("Finished!")
		
	}
	
	override func didReceiveMemoryWarning() {
		
		log.debug("Started!")
		
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
		log.debug("Finished!")
		
	}
	
	// MARK: - Segues
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		log.debug("Started!")
		
		if segue.identifier == "showGlobalProducts" {
			
			log.debug("Top Detail View Controller : \((segue.destinationViewController as! UINavigationController).topViewController)")
			let controller = (segue.destinationViewController as! UINavigationController).topViewController as! GlobalProductsListTableViewController
			
			controller.delegate = self
		
			controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
			controller.navigationItem.leftItemsSupplementBackButton = true

		}
		
		log.debug("Finished!")
		
	}

    // MARK: - UITableViewDataSource Methods

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		
		log.debug("Started!")
		
		if searchController.active && searchController.searchBar.text != "" {
			
			return 1
			
		} else {
			
			guard shoppingList != nil else {
				
				log.debug("Finished!")
				
				return 0
				
			}
			
			guard let productCategoriesInThisShoppingList = self.shoppingList?.categoryList else {
				
				log.debug("Finished!")
				
				return 0
				
			}
			
			log.debug("Finished!")
			
			return productCategoriesInThisShoppingList.count
			
		}
		
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		log.debug("Started!")
		
		if searchController.active && searchController.searchBar.text != "" {
			
			return filteredProductsList.count
			
		} else {
			
			guard shoppingList != nil else {
				
				log.debug("Finished!")
				
				return 0
				
			}
			
			guard shoppingList?.categoryList?.count > 0 else {
				
				log.debug("Finished!")
				
				return 0
				
			}
			
			guard let categoryKey = shoppingList?.categoryList![section] else {
				
				log.debug("Finished!")
				
				return 0
				
			}
			
			log.debug("Finished!")
			
			return shoppingList!.totalNumberOfProductsInCategoryWithName(categoryKey)
			
		}

    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		log.debug("Started!")
		
		let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath)
		
		if let categoryName = shoppingList?.categoryList?[indexPath.section] {
			
			if let productsInCategory = shoppingList?.products[categoryName] {
				
				var product: Product
				
				if searchController.active && searchController.searchBar.text != "" {
					
					product = filteredProductsList[indexPath.row]
					
				} else {
					
					product = productsInCategory[indexPath.row]
					
				}
				
				cell.textLabel!.text = product.name
//				cell.detailTextLabel!.text = "Category: \(product.category.name)"
				
				
				cell.imageView!.image = UIImage(named: "productIcon")
				cell.imageView!.image = cell.imageView!.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
				
				//Standard Blue Color : colorWithRed:14.0/255 green:122.0/255 blue:254.0/255 alpha:1.0
				
				cell.imageView!.tintColor = UIColor(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
				
			}
			
		}

		log.debug("Finished!")
		
		return cell

    }
	
	
	// MARK: - UITableViewDelegate Methods
	
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		log.debug("Started!")
		
		log.debug("Finished!")
		
		return CGFloat(28)
		
		
	}
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		log.debug("Started!")
		
		let title = shoppingList?.categoryList?[section]
		
		// Dequeue with the reuse identifier
		let headerView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("ProductsTableHeaderSectionView")
		let header = headerView as! ProductsTableHeaderSecionView
		header.headerTitle.text = title
		
		log.debug("Finished!")
		
		return headerView
		

	}



    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	
	// MARK: - GlobalProductsListTableViewControllerDelegate Methods
	
	func globalProductsListTableViewControllerDidTapCancel() {
		
		log.debug("Started!")
		
		self.dismissViewControllerAnimated(true, completion: nil)
		
		log.debug("Finished!")
		
	}
	
	func currentProductsInShoppingList() -> [Product]? {
		
		log.debug("Started!")
		
		var allProductsInShoppingList = [Product]()
		
		guard let shoppingListProductCategories = shoppingList?.categoryList else {
			
			log.debug("Finished!")
			
			return nil
			
		}
		
		for categoryName in shoppingListProductCategories {
			
			guard let productsInCategory = shoppingList?.products[categoryName] else {
				
				continue
				
			}
			
			if productsInCategory.count > 0 {
				
				for product in productsInCategory {
					
					allProductsInShoppingList.append(product)
					
				}
				
			}

		}
		
		log.debug("Finished!")
		
		return allProductsInShoppingList
		
	}
	
	func addProductsToShoppingList(productsToAdd: [Product]?) {
		
		log.debug("Started!")
		
		guard productsToAdd != nil else {

			log.debug("Finished!")
			
			self.dismissViewControllerAnimated(true, completion: nil)
			
			return
			
		}
		
		for product in productsToAdd! {
			
			self.shoppingList?.addProduct(product)
			
		}
		
		self.dismissViewControllerAnimated(true, completion: {self.tableView.reloadData()})
		
		log.debug("Finished!")
		
	}
	
	
	// MARK: - Custom Methods
	
	func registerNibs() {
		
		log.debug("Started!")
		
		let nib = UINib(nibName: "ProductsTableHeaderSectionView", bundle: nil)
		tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "ProductsTableHeaderSectionView")
		
		log.debug("Finished!")
		
	}
	
	func setupSearch() {
		
		log.debug("Started!")
		
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar
		
		log.debug("Finished!")
		
	}
	
	func filterContentForSearchText(searchText: String, scope: String = "All") {
		
		log.debug("Started!")
		
		for (_, value) in (shoppingList?.products)! {
			
			let productsInCat = value as [Product]
			
			log.debug("\(productsInCat)")
			
			filteredProductsList = productsInCat.filter { product in
				
				log.debug("\(product.name.lowercaseString.containsString(searchText.lowercaseString))")
				
				return product.name.lowercaseString.containsString(searchText.lowercaseString)
				
			}

		}

		
		//		filteredShoppingLists = shoppingLists.filter({( shoppingListName : String) -> Bool in
		//
		//			let categoryMatch = (scope == "All") || (candy.category == scope)
		//
		//			return categoryMatch && candy.name.lowercaseString.containsString(searchText.lowercaseString)
		//
		//		})
		
		tableView.reloadData()
		
		log.debug("Finished!")
		
	}

}

extension ShoppingListViewController: UISearchBarDelegate {
	
	// MARK: - UISearchBar Delegate
	func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		
		log.debug("Started!")
		
		filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
		
		log.debug("Finished!")
		
	}
	
}

extension ShoppingListViewController: UISearchResultsUpdating {
	
	// MARK: - UISearchResultsUpdating Delegate
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		
		log.debug("Started!")
		
		filterContentForSearchText(searchController.searchBar.text!)
		
		//		let searchBar = searchController.searchBar
		//		let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
		//		filterContentForSearchText(searchController.searchBar.text!, scope: scope)
		
		log.debug("Finished!")
		
	}
		
		
}

