//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nilesh Kumar on 13/06/18.
//  Copyright © 2018 NKM. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories = [Category]() // Item of type entity
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        loadItems()
     
    }

   
    //MARK: - Add New Entries
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user click on add button
            
           
            let newCategory = Category()
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.save(category: newCategory)
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
        
       
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategories = categories[indexPath.row]
        }
        
    }
    
    
    //MARK: - DATA Manipulation
    func save(category: Category){
        
        do {
            
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Erro saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
//    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
//
//        do {
//            categories =  try context.fetch(request)
//        } catch {
//            print("Error Fetching request \(error)")
//        }
//
//        tableView.reloadData()
//
//    }
    
    
}
