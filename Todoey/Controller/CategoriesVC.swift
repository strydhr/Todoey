//
//  CategoriesVC.swift
//  Todoey
//
//  Created by Satyia Anand on 23/04/2018.
//  Copyright © 2018 Satyia Anand. All rights reserved.
//

import UIKit
import CoreData

class CategoriesVC: UITableViewController {
    var CategoryArray = [Category]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    
    
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.CategoryArray.append(newCategory)
            self.saveCategory()
            
            
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
        return CategoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = CategoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = CategoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Method
    
    func saveCategory(){
        do{
            try context.save()
        }catch{
            print("Unable to save: \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            CategoryArray = try context.fetch(request)
        }catch{
            print("error loading: \(error)")
        }
        tableView.reloadData()
    }

    
  
}
