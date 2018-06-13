//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nilesh Kumar on 13/06/18.
//  Copyright © 2018 NKM. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var itemArray = [Category]() // Item of type entity
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadItems()
     
    }

   
    //MARK: - Add New Entries
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user click on add button
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.itemArray.append(newCategory)
            
            self.saveItems()
        }
        
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    
    //MARK: - Table View Delegate Methods
    
    
    //MARK: - DATA Manipulation
    func saveItems(){
        
        do {
            
            try context.save()
        } catch {
            print("Erro saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            itemArray =  try context.fetch(request)
        } catch {
            print("Error Fetching request \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
}
