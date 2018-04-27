//
//  ViewController.swift
//  Todoey
//
//  Created by Satyia Anand on 20/04/2018.
//  Copyright © 2018 Satyia Anand. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var toDoitems: Results<Items>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.separatorStyle = .none
      
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
            
            title = selectedCategory?.name
            guard let hexColor = selectedCategory?.hexColor else {fatalError("NaviController diesnt not exits")}
            update(withHexcode: hexColor)
    }
    override func viewWillDisappear(_ animated: Bool) {
        update(withHexcode: "1D9BF6")
    }
    //MARK: - NavbarSetup
    func update(withHexcode  colorHex: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("NaviController diesnt not exits")}
        guard let navBarColor = HexColor(colorHex) else {fatalError()}
            navBar.barTintColor  = navBarColor
            
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
            
            searchBar.barTintColor = navBarColor
        
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoitems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoitems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            let parentColor = HexColor(selectedCategory!.hexColor)
            
            if let color = parentColor?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoitems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
             cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
            print("no items")
        }
        

        return cell
    }
    
    //MARK: - TableView Delegate Methode
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if let item = toDoitems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
              
            }
            }catch{
                print("Error saving data:\(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
               
                do{
                    try self.realm.write {
                        let newItem = Items()
                        newItem.title = textField.text!
                        print("current datetime is: \(newItem.date)")
                        currentCategory.items.append(newItem)
                        
                    }
                    
                    
                }catch{
                    print("Error saving context \(error)")
                    
                }
                
            }
            
            self.tableView.reloadData()
         

           

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField


        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func loadItems(){
        
        toDoitems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)


        tableView.reloadData()
    }
    override func updateModel(at indexpath: IndexPath) {
        if let item = toDoitems?[indexpath.row] {
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("Error deleting item: \(error)")
            }
        }
    }

}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoitems = toDoitems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)

        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

