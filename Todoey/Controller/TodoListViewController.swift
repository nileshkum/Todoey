//
//  ViewController.swift
//  Todoey
//
//  Created by Nilesh Kumar on 06/06/18.
//  Copyright © 2018 NKM. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    
 var todoItems: Results<Item>!
 let realm = try! Realm()
    
 var selectedCategory : Category? {
        
        didSet {
            loadItems()
        }
    }

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            
            cell.textLabel?.text = "No items added"
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    //MARK - Table View Delegate Methods // What happens when we cliack on cells
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                item.done = !item.done
            }
            } catch {
                print("Error SAving Itesm, \(error)")
            }
        }
        tableView.reloadData()
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // this replace below line
//        saveItems()
  
        // Animation on selection
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK - Add new Section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user click on add button
            
            if let currentCategory = self.selectedCategory{
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                }
                } catch {
                }
            }
             self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK Model Manipulation
    
    
    func loadItems() { //give default value

       todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
}

////MARK: Search bar Extensio
//extension TodoListViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//
//        // Filters
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request,predicate: predicate)
//
//    }
//
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            if searchBar.text?.count == 0{
//                loadItems()
//
//                DispatchQueue.main.async {
//                     searchBar.resignFirstResponder() // this method stops all activity on screen
//                }
//
//
//            }
//        }
//}

