//
//  AddProductTableViewController.swift
//  APShopper
//
//  Created by Abrar Peer on 23/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import UIKit

protocol GlobalProductsListTableViewControllerDelegate {
	
	func globalProductsListTableViewControllerDidTapCancel()
	
	func currentProductsInShoppingList() -> [Product]?
	
	func addProductsToShoppingList(productsToAdd: [Product]?)
	
	
}

class GlobalProductsListTableViewController: UITableViewController {
	
	let searchController = UISearchController(searchResultsController: nil)
	
	let datastore = DataStore()
	
	var productsForSelectionList = [String :[Product]]() {
		
		didSet {
			
			if let productsInShoppingList = self.delegate?.currentProductsInShoppingList() {
				
				for product in productsInShoppingList {
					
					if let productsInCategory = productsForSelectionList[product.category.name] {
						
						if let index = productsInCategory.indexOf(product) {
							
							var productsInCat = productsInCategory
							
							productsInCat.removeAtIndex(index)
							
							productsForSelectionList[product.category.name] = productsInCat
							
						}
						
					}
					
				}
				
			}
			
			for (key, _) in productsForSelectionList {
				
				if categoriesForSelectionList.contains(key) {
					
					continue
					
				} else {
					
					categoriesForSelectionList.append(key)
				}
				
			}
			
			log.debug("Products = \(productsForSelectionList)")
			log.debug("Categories = \(categoriesForSelectionList)")
			
		}
		
	}
	
	var productsToAdd = [Product]()
	
	var filteredProductsList = [Product]()
	
	var categoriesForSelectionList = [String]()
	
	var delegate : GlobalProductsListTableViewControllerDelegate?

	override func viewDidLoad() {
		
		log.debug("Started!")
		
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		//self.configureView()
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action:"didTapCancelButton")
		
		
		var addToListButtonImage = UIImage(named: "addToList")
		addToListButtonImage = addToListButtonImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
		

		let addToListButton = UIBarButtonItem(image: addToListButtonImage!, landscapeImagePhone: addToListButtonImage!, style: .Done, target: self, action: "didTapAddProducts")
		
		var newProductButtonImage = UIImage(named: "newProduct")
		newProductButtonImage = newProductButtonImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
		
		let newProductButton = UIBarButtonItem(image: newProductButtonImage!, landscapeImagePhone: newProductButtonImage!, style: .Done, target: self, action: "didTapAddProduct")

		self.navigationItem.rightBarButtonItems = [addToListButton, newProductButton]
		
		productsForSelectionList = datastore.globalProducts
		
		registerNibs()
		
		log.debug("Finished!")
		
	}
	
	
    override func didReceiveMemoryWarning() {
		
		log.debug("Started!")
		
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
		
		log.debug("Finished!")
		
    }

    // MARK: - UITableViewDataSource Methods

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		
		log.debug("Started!")
		
        // #warning Incomplete implementation, return the number of sections
		
		log.debug("Finished!")
		
        return categoriesForSelectionList.count
		
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		
		log.debug("Started!")
		
		// #warning Incomplete implementation, return the number of rows
		
		let categoryName = categoriesForSelectionList[section]
		
		guard let productsInCat = productsForSelectionList[categoryName] else {
			
			log.debug("Finished!")
			
			return 0
			
		}
		
		log.debug("Finished!")
		
        return productsInCat.count
		
    }


	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		log.debug("Started!")
		
		let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath)
		
		let categoryName = categoriesForSelectionList[indexPath.section]
		
		var productForCell : Product
		
		guard let productsInCat = productsForSelectionList[categoryName] else {
			
			log.debug("Finished!")
			
			return cell
		}
		
		if searchController.active && searchController.searchBar.text != "" {
			
			productForCell = filteredProductsList[indexPath.row]
			
		} else {
			
			productForCell = productsInCat[indexPath.row]
			
		}
				
		cell.textLabel!.text = productForCell.name
		cell.detailTextLabel!.text = "Category: \(productForCell.category.name)"
		cell.accessoryType = .None
		cell.imageView!.image = UIImage(named: "productIcon")
		cell.imageView!.image = cell.imageView!.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
		
		//Standard Blue Color : colorWithRed:14.0/255 green:122.0/255 blue:254.0/255 alpha:1.0
		
		cell.imageView!.tintColor = UIColor(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
		
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
		
		let title = categoriesForSelectionList[section]
		
		// Dequeue with the reuse identifier
		let headerView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("ProductsTableHeaderSectionView")
		let header = headerView as! ProductsTableHeaderSecionView
		header.headerTitle.text = title
		
		log.debug("Finished!")
		
		return headerView
		
		
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		log.debug("Started!")
		
		guard let cell = self.tableView.cellForRowAtIndexPath(indexPath) else {
			
			log.debug("Finished!")
			
			return
			
		}
		
		if (cell.accessoryType == .None) {
			
			cell.accessoryType = .Checkmark
			
			let categoryName = categoriesForSelectionList[indexPath.section]
			
			guard let productsInCat = productsForSelectionList[categoryName] else {
				
				log.debug("Finished!")
				
				return
				
			}
			
			
			let product = productsInCat[indexPath.row]
			
			productsToAdd.append(product)
			
		} else {
			
			cell.accessoryType = .None
			
			let categoryName = categoriesForSelectionList[indexPath.section]
			
			guard let productsInCat = productsForSelectionList[categoryName] else {
				
				log.debug("Finished!")
				
				return
				
			}
			
			
			let product = productsInCat[indexPath.row]
			
			if let index = productsToAdd.indexOf(product) {
				
				productsToAdd.removeAtIndex(index)
				
			}

		}
		
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
	
	//MARK: Custom Methods
	
	func insertNewProduct(newName: String) {
		
		log.debug("Started!")
		
//		let searchShopingList = shoppingLists.filter({
//			$0.name == newName
//		})
//		
//		guard searchShopingList.count == 0 else {
//			
//			warnOfExistingShoppingListName(newName)
//			
//			return
//			
//		}
		
		let customCategory = Category(name: "Custom")
		
		if datastore.getAllProductsInCategory(customCategory)?.count < 1 {
			
			if !datastore.globalCategories.contains(customCategory) {
				
				datastore.globalCategories.append(customCategory)
				
			}
			
		}
		
		let newProduct = Product(name: newName, category: customCategory)
		
		datastore.addProduct(newProduct)
		
		productsForSelectionList = datastore.globalProducts
		
//		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//		self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		
		self.tableView.reloadData()
		
		log.debug("Finished!")
		
	}

	
	func registerNibs() {
		
		log.debug("Started!")
		
		let nib = UINib(nibName: "ProductsTableHeaderSectionView", bundle: nil)
		tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "ProductsTableHeaderSectionView")
		
		log.debug("Finished!")
		
	}

	
	func setupProductsSelectionList() {
		
		log.debug("Started!")
		
		productsForSelectionList = datastore.globalProducts
		
//		if let productsInShoppingList = self.delegate?.currentProductsInShoppingList() {
//			
//			for product in productsInShoppingList {
//				
//				if let productsInCategory = productsForSelectionList[product.category.name] {
//					
//					if let index = productsInCategory.indexOf(product) {
//						
//						var productsInCat = productsInCategory
//						
//						productsInCat.removeAtIndex(index)
//						
//						productsForSelectionList[product.category.name] = productsInCat
//						
//					}
//					
//				}
//				
//			}
//			
//		}
//		
//		for (key, _) in productsForSelectionList {
//			
//			if categoriesForSelectionList.contains(key) {
//				
//				continue
//				
//			} else {
//				
//				categoriesForSelectionList.append(key)
//			}
//			
//		}
//		
//		log.debug("Products = \(productsForSelectionList)")
//		log.debug("Categories = \(categoriesForSelectionList)")

		log.debug("Finished!")
		
	}
	
	//MARK: Action Methods
	
	func didTapCancelButton() {
		
		log.debug("Started!")
		
		log.debug("Finished!")
		
		self.delegate?.globalProductsListTableViewControllerDidTapCancel()
		
	}
	
	func didTapAddProducts() {
		
		log.debug("Started!")
		
		log.debug("Finished!")
		
		self.delegate?.addProductsToShoppingList(productsToAdd)
		
	}
	
	func didTapAddProduct() {
		
		log.debug("Started!")
		
		let newProductListAlertController = UIAlertController(title: "Name this Product", message: "Please give this product a name", preferredStyle: .Alert)
		newProductListAlertController.addTextFieldWithConfigurationHandler(nil)
		
		
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(alert: UIAlertAction!) in
			
			self.dismissViewControllerAnimated(true, completion: nil)
			
		})
		
		
		let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {(alert: UIAlertAction!) in
			
			guard let newProductNameTextField = newProductListAlertController.textFields?[0] else {
				
				return
				
			}
			// do something interesting with "answer" here
			
			guard let newProducttName = newProductNameTextField.text else {
				
				return
				
			}
			
//			self.dismissViewControllerAnimated(true, completion: nil)
			
			self.insertNewProduct(newProducttName)
			
			
			
		})
		
		
		newProductListAlertController.addAction(cancelAction)
		newProductListAlertController.addAction(saveAction)
		
		newProductListAlertController.view.setNeedsLayout()
		
		presentViewController(newProductListAlertController, animated: true, completion: nil)
		
		log.debug("Finished!")

		
	}
	
	
}
