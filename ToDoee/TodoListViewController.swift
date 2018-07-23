//
//  TodoListViewController.swift
//  ToDoee
//
//  Created by CURTIS DUNNE on 7/23/18.
//  Copyright © 2018 CURTIS DUNNE. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: UITableViewDataSource Delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell") {
            cell.textLabel?.text = itemArray[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: UITableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected \(itemArray[indexPath.row])")

        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
    }
}

