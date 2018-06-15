//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nilesh Kumar on 13/06/18.
//  Copyright © 2018 NKM. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadCategories()

        tableView.separatorStyle = .none
    }

   
    //MARK: - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]  {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else { fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - Add New Entries
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen when user click on add button
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Category"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Save Categories
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            
        }
        
        tableView.reloadData()
    }
    
    //MARK: Load Categories
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: Delete Section
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {

            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch {
                print("Error deleting Items \(error)")
            }
        }
    }
    
}

