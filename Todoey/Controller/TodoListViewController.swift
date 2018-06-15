//
//  ViewController.swift
//  Todoey
//
//  Created by Nilesh Kumar on 06/06/18.
//  Copyright © 2018 NKM. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
 var itemArray = [Item]() // Item of type entity
    
 var selectedCategories : Category? {
        
        didSet {
//            loadItems()
        }
    }

 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary OPerator
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //MARK - Table View Delegate Methods // What happens when we cliack on cells
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // this replace below line
        
        saveItems()
  
    
        // Animation on selection
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK - Add new Section
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user click on add button
            
            
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategories
//            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK Model Manipulation
    
    func saveItems(){
        
        do {
            
            try context.save()
        } catch {
            print("Erro saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ){ //give default value
//
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategories!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate!] )
////
////        request.predicate = compoundPredicate
//
//        do {
//        itemArray =  try context.fetch(request)
//        } catch {
//            print("Error Fetching request \(error)")
//        }
//
//        tableView.reloadData()
//
//    }
    
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

