//
//  ViewController.swift
//  Todoey
//
//  Created by Nilesh Kumar on 06/06/18.
//  Copyright © 2018 NKM. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    
 let realm = try! Realm()
 var todoItems: Results<Item>!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        
        didSet {
            loadItems()
        }
    }

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
   tableView.separatorStyle = .none
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        guard let colorHex = selectedCategory?.color else { fatalError()}
        
        updateNavBar(withHexColor: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
        updateNavBar(withHexColor: "1D9BF6")
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                }
            
            
            
        } else {
    
            cell.textLabel?.text = "No items added"
        }
        
        return cell
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
                    newItem.createdDate = Date()
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                
            }
        }
    }
    
    //MARK: Navigation Bar Color
    func updateNavBar(withHexColor colorHexCode: String){
         guard let navBar = navigationController?.navigationBar  else {fatalError("Navigation Controller does not exist")}
         guard let navbarColor = UIColor(hexString: colorHexCode) else { fatalError()}
        
        title = selectedCategory?.name
        navBar.barTintColor    = navbarColor
        navBar.tintColor       = ContrastColorOf(navbarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navbarColor, returnFlat: true)]
        searchBar.barTintColor = navbarColor
        
    }
    
}

////MARK: Search bar Extension
extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {


        // Filters
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()
    }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0{
                
                loadItems()

                DispatchQueue.main.async {
                     searchBar.resignFirstResponder() // this method stops all activity on screen
                }


            }
        
    }
}
