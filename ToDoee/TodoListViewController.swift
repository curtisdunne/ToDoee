//
//  TodoListViewController.swift
//  ToDoee
//
//  Created by CURTIS DUNNE on 7/23/18.
//  Copyright © 2018 CURTIS DUNNE. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray: [Item] = [Item]()
    
    var category: Category? {
        didSet {
            loadItems()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let category = self.category {
            navigationItem.title = category.name
        } else {
            navigationItem.title = "Items"
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func loadItems(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        if let category = self.category {
            if let name = category.name {
                let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", name)
                
                if let predicate = predicate {
                    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
                    request.predicate = compoundPredicate
                } else {
                    request.predicate = categoryPredicate
                }
            } else {
                request.predicate = predicate
            }
        } else {
            request.predicate = predicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching Item data from Context")
        }
    }
    
    // MARK: UITableViewDataSource Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell") {
            let item = itemArray[indexPath.row]

            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: UITableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.done = !item.done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new items
    @IBAction func addButtonTapped(_ sender: Any) {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoee Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text {
                
                let newItem = Item(context: self.context)

                newItem.title = text
                newItem.done = false
                newItem.parentCategory = self.category
                
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving Context")
        }
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        if let searchText = searchBar.text {
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            do {
                itemArray = try context.fetch(request)
                tableView.reloadData()
            } catch {
                print("Error fetching data from Context")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

