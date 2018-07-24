//
//  CategoryViewController.swift
//  ToDoee
//
//  Created by CURTIS DUNNE on 7/24/18.
//  Copyright © 2018 CURTIS DUNNE. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray: [Category] = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemsVC = segue.destination as? TodoListViewController {
            itemsVC.category = sender as? Category
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    // MARK: Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") {
            let category = categoryArray[indexPath.row]

            cell.textLabel?.text = category.name
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: categoryArray[indexPath.row])
    }
    
    // MARK: Data manipulation methods
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching Category data from Context: \(error)")
        }
        
    }

    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving Category context")
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let text = textField.text {
                let newCategory = Category(context: self.context)
                
                newCategory.name = text
                
                self.categoryArray.append(newCategory)
                
                self.saveCategory()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        if let searchText = searchBar.text {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
            
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            do {
                categoryArray = try context.fetch(request)
                tableView.reloadData()
            } catch {
                print("Error fetching Category data from Context")
            }
        }
    }
    
}

