//
//  TodoListViewController.swift
//  ToDoee
//
//  Created by CURTIS DUNNE on 7/23/18.
//  Copyright © 2018 CURTIS DUNNE. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [Item] = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()

            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding Items Array, \(error)")
            }
            
            tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell") {
            cell.textLabel?.text = itemArray[indexPath.row].title
            
            let item = itemArray[indexPath.row]
            
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
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new items
    @IBAction func addButtonTapped(_ sender: Any) {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoee Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text {
                let newItem = Item()
                newItem.title = text
                newItem.done = false
                
                self.itemArray.append(newItem)
                
                self.saveItems()

                self.tableView.reloadData()
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding array, \(error)")
        }
    }
}

