//
//  ViewController.swift
//  Todoey
//
//  Created by Sopheap Sopheadavid on 7/17/19.
//  Copyright © 2019 Sopheap Sopheadavid. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController : UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    // MARK: - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    // MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //Select each row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(itemArray[indexPath.row])
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    @IBAction func buttonAddPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            // to store data on local storage identified by TodoListArray key
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Save items
    // Save iteams in Core Data
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: - Load Items
    // load items from Core Data
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        
//        request.predicate = compoundPredicate

        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Fetch data error \(error)")
        }
        tableView.reloadData()

    }
    
}
//MARK: - Search bar method
extension TodoListViewController : UISearchBarDelegate {
    
    // This function used for serch
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // fetch data from Core Data
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // CONTAINS mean that the left hand side contains the right hand side
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Sort data by ascending
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //Catch Exception
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Fetch data error \(error)")
        }
        
        // Load and Reload items on the table
        loadItems(with : request, predicate: predicate)
        tableView.reloadData()
        
    }
    
    // This function used for when string on search bar is empty cursor and keyboard will be disppear on screen
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
}

