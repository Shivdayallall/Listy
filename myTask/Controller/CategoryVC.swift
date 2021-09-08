//
//  CategoryVC.swift
//  myTask
//
//  Created by shiv on 8/25/21.
//

import UIKit
import RealmSwift

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alert = UIAlertController()
    var textField = UITextField()
    
    let realm = try! Realm()
    var categoriesArray: Results<Category>?
    
    let floatingBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .systemTeal
        // add image to button
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.tintColor = .white
        button.setImage(image, for: .normal)
        // add shadow to button
        // button.layer.masksToBounds = true. with this enable it will cause shadow to disapear
        button.layer.cornerRadius = 30
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        loadCategories()
        view.addSubview(floatingBtn)
        // print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingBtn.frame = CGRect(x: view.frame.size.width - 70, y: view.frame.size.height - 100, width: 60, height: 60)
        floatingBtn.addTarget(self, action: #selector(addNewCategory), for: .touchUpInside)
    }
    
    
    // enable second action in the array if the text in textfield is greater than 0
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        alert.actions[1].isEnabled = sender.text!.count > 0
    }
    
    @objc func addNewCategory() {
        // configure the uiAlert
        alert = UIAlertController(title: "Add A New Category", message: "", preferredStyle: .alert)
        
        // Add two action to uiAlert
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let addCategory = UIAlertAction(title: "Add Category", style: .default) { addCate in
            let newCategory = Category()
            newCategory.categoryName = self.textField.text!.capitalized
            self.saveCategory(newCategory: newCategory)
        }
        
        // Add each button action to the uiAlert
        alert.addAction(cancel)
        alert.addAction(addCategory)
        
        // disable addCategory btn until validation is true
        addCategory.isEnabled = false
        
        // Add a textFiled to the uiAlert
        alert.addTextField { textField in
            self.textField = textField
            textField.placeholder = "New Category"
            textField.keyboardType = UIKeyboardType.default
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        // Present  UIAlert
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = categoriesArray?[indexPath.row].categoryName
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (contextualAction, view, actionPerformed: (Bool) -> ()) in
            if let catergory = categoriesArray?[indexPath.row] {
                
                do {
                    try realm.write {
                        realm.delete(catergory)
                    }
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                }
                catch {
                    print("Item not deleted")
                }
            }
            
        }
        
        delete.image = UIImage(systemName: "trash")
        
        tableView.reloadData()

        return UISwipeActionsConfiguration(actions: [delete])
    }


  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "taskSegue", sender: self)
    }
    
    // Segue to selected items from selected Category
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
        }
    }
    
}

//MARK: - The realm functions responsible for saving the user data from the category and also loading the save users category
extension CategoryVC {
    
    // Save new category
    func saveCategory(newCategory: Category) {
        
        do {
            try realm.write({
                realm.add(newCategory)
            })
            
        } catch {
            print("Error loading new category \(error.localizedDescription)")
        }
        
        tableView.reloadData()
        
    } // close save category function
    
    // Load saved categories
    func loadCategories() {
        
        categoriesArray = realm.objects(Category.self)
        tableView.reloadData()
        
    } // close load catergory functions
    
    
} // close extension
