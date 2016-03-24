//
//  MasterViewController.swift
//  APShopper
//
//  Created by Abrar Peer on 22/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import UIKit

class ShoppingListsViewController: UITableViewController, UISearchDisplayDelegate {
	
	let searchController = UISearchController(searchResultsController: nil)

	var detailViewController: ShoppingListViewController? = nil
	
	let datastore = DataStore.sharedInstance
	
	var shoppingLists = [ShoppingList]()
	
	var filteredShoppingLists = [ShoppingList]()
	
	override func viewDidLoad() {
		
		log.debug("Started!")
		
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem()
		
		var newShoppingListImage = UIImage(named: "newShoppingList")
		newShoppingListImage = newShoppingListImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
		
		let newShoppingListBarButtonItem = UIBarButtonItem(image: newShoppingListImage!, landscapeImagePhone: newShoppingListImage!, style: .Plain, target: self, action: "promptForShoppingListName")

		self.navigationItem.rightBarButtonItem = newShoppingListBarButtonItem
		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ShoppingListViewController
		}
		
		setupSearch()
		
		shoppingLists = datastore.allMyShoppingLists
		
		log.debug("Finished!")
		
	}

	override func viewWillAppear(animated: Bool) {
		
		log.debug("Started!")
		
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
		super.viewWillAppear(animated)
		
		self.tableView.reloadData()	
		
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
		
		if segue.identifier == "showShoppingList" {
		    if let indexPath = self.tableView.indexPathForSelectedRow {
		        let shoppingList = shoppingLists[indexPath.row]
				
				log.debug("Top Detail View Controller : \((segue.destinationViewController as! UINavigationController).topViewController)")
		        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! ShoppingListViewController
		        controller.shoppingList = shoppingList
		        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}

		log.debug("Finished!")
		
	}

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		
		log.debug("Started!")
		
		log.debug("Finished!")
		
		return 1
		
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		log.debug("Started!")
		
		if searchController.active && searchController.searchBar.text != "" {
			
			log.debug("Finished!")
			return filteredShoppingLists.count
			
		}
		
		log.debug("Finished!")
		
		return shoppingLists.count
		
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		log.debug("Started!")
		
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		
		let shoppingList: ShoppingList
		
		if searchController.active && searchController.searchBar.text != "" {
			
			shoppingList = filteredShoppingLists[indexPath.row]
			
		} else {
			
			shoppingList = shoppingLists[indexPath.row]
		}

		cell.textLabel!.text = shoppingList.name
		cell.detailTextLabel!.text = "Contains \(shoppingList.totalNumberOfProductsInList)"
		
		
		cell.imageView!.image = UIImage(named: "shoppingListIcon")
		cell.imageView!.image = cell.imageView!.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
		
		//Standard Blue Color : colorWithRed:14.0/255 green:122.0/255 blue:254.0/255 alpha:1.0
		
		cell.imageView!.tintColor = UIColor(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
		
		log.debug("Finished!")
		
		return cell
		
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		
		log.debug("Started!")
		
		log.debug("Finished!")
		
		return true
		
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		log.debug("Started!")
		
		if editingStyle == .Delete {
		    shoppingLists.removeAtIndex(indexPath.row)
		    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		} else if editingStyle == .Insert {
		    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
		
		log.debug("Finished!")
		
	}
	
	// MARK: - Custom Methods
	
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
		
		filteredShoppingLists = shoppingLists.filter { shoppingList in
			
			return shoppingList.name.lowercaseString.containsString(searchText.lowercaseString)
			
		}
		
		tableView.reloadData()
		
		log.debug("Finished!")
		
	}
	
	func insertNewShoppingList(newName: String) {
		
		log.debug("Started!")
		
		let searchShopingList = shoppingLists.filter({
			$0.name == newName
		})
		
		guard searchShopingList.count == 0 else {
			
			warnOfExistingShoppingListName(newName)
			
			return
			
		}
		
		shoppingLists.insert(ShoppingList(name: newName), atIndex: 0)

		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
		self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		
		log.debug("Finished!")
		
	}

	
	func promptForShoppingListName() {
		
		log.debug("Started!")
		
		let newShoppingListAlertController = UIAlertController(title: "Name this Shopping List", message: "Please give this shopping list a name", preferredStyle: .Alert)
		newShoppingListAlertController.addTextFieldWithConfigurationHandler(nil)
		
		
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(alert: UIAlertAction!) in
			
			self.dismissViewControllerAnimated(true, completion: nil)
		
		})
		
		
		let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {(alert: UIAlertAction!) in
			
			guard let newShoppingListNameTextField = newShoppingListAlertController.textFields?[0] else {
				
				return
				
			}
			// do something interesting with "answer" here
			
			guard let newShoppingListName = newShoppingListNameTextField.text else {
				
				return
				
			}
			
			self.dismissViewControllerAnimated(true, completion: nil)
			
			self.insertNewShoppingList(newShoppingListName)
			
			
			
			
		})
		
		
		newShoppingListAlertController.addAction(cancelAction)
		newShoppingListAlertController.addAction(saveAction)
		
		newShoppingListAlertController.view.setNeedsLayout()
		
		presentViewController(newShoppingListAlertController, animated: true, completion: nil)
		
		log.debug("Finished!")
		
	}
	
	func warnOfExistingShoppingListName(duplicateName: String) {
		
		
		log.debug("Started!")
		
		let duplicateShoppingListNameWarningAlertController = UIAlertController(title: "Shopping List Already Exists", message: "Shopping List with name '\(duplicateName)' already exists. You can either create a shopping list with another name, or you could delete the shopping list with name \(duplicateName).", preferredStyle: .Alert)
		
		let okAction = UIAlertAction(title: "OK", style: .Default, handler: {(alert: UIAlertAction!) in
			
			self.dismissViewControllerAnimated(true, completion: nil)
			
		})
		
		duplicateShoppingListNameWarningAlertController.addAction(okAction)
		
		duplicateShoppingListNameWarningAlertController.view.setNeedsLayout()
		
		presentViewController(duplicateShoppingListNameWarningAlertController, animated: true, completion: nil)
		
		log.debug("Finished!")
		
	}


}

extension ShoppingListsViewController: UISearchBarDelegate {
	
	// MARK: - UISearchBar Delegate
	func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		
		log.debug("Started!")
		
		filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
		
		log.debug("Finished!")
		
	}
	
}

extension ShoppingListsViewController: UISearchResultsUpdating {
	
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

