//
//  CategoriesVC.swift
//  Todoey
//
//  Created by Satyia Anand on 23/04/2018.
//  Copyright © 2018 Satyia Anand. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoriesVC: SwipeTableVC {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        tableView.separatorStyle = .none
    }
    
    
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.hexColor = String(UIColor.randomFlat.hexValue())
            
            
            self.save(category: newCategory)
            
            
        }
        alert.addTextField { (addtextField) in
            addtextField.placeholder = "Category Name"
            textField = addtextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Category added"
        
        cell.backgroundColor = HexColor((category?.hexColor)!)
        
        cell.textLabel?.textColor = ContrastColorOf(HexColor((category?.hexColor)!)!, returnFlat: true)

        return cell
    }
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Method
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Unable to save: \(error)")
        }
        tableView.reloadData()
    }
    func loadCategory(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    //MARK: - SWipe delete method
    override func updateModel(at indexpath: IndexPath) {
        if let category = categories?[indexpath.row]{
            let itemsInCatergory = category.items
            do{
                try realm.write {
                    realm.delete(itemsInCatergory)
                    realm.delete(category)
                    
                }
            }catch{
                print("Error deleting item: \(error)")
            }
        }
    }
    
  
}
