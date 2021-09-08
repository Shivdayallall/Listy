//
//  ViewController.swift
//  myTask
//
//  Created by shiv on 10/20/20.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tabelview: UITableView!
    
    var taskArray: Results<Items>?
    var textField = UITextField()
    var alert = UIAlertController()
    lazy var realm = try! Realm()
    
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
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedCategory?.categoryName
        
        tabelview.delegate = self
        tabelview.dataSource = self
        
        view.addSubview(floatingBtn)
        
        // loadData()
        // print(Realm.Configuration.defaultConfiguration.fileURL!)
        // command + shift + g
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingBtn.frame = CGRect(x: view.frame.size.width - 70, y: view.frame.size.height - 100, width: 60, height: 60)
        floatingBtn.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        alert.actions[1].isEnabled = sender.text!.count > 0
    }
    
    @objc func addNewTask() {
        alert = UIAlertController(title: "Add A New Task", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { add in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                        let item = Items()
                        item.name = self.textField.text!.capitalized
                        currentCategory.todoItem.append(item)
                        // self.SaveData(newItem: item)
                    })
                    
                } catch {
                    print("Error saving new task \(error.localizedDescription)")
                }
            }
            self.tabelview.reloadData()
            
        }
        
        addAction.isEnabled = false
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        alert.addTextField { [self] field in
            self.textField = field
            textField.placeholder = "New Task"
            textField.keyboardType = UIKeyboardType.default
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let index = IndexPath(row: self.taskArray!.count-1, section: 0)
            self.tabelview.scrollToRow(at: index, at: .bottom, animated: true)
        }
    }
    
    func SaveData(newItem: Items) {
        do {
            try  realm.write {
                realm.add(newItem)
                scrollToBottom()
            }
        }
        catch  {
            print("Error saving \(Error.self)")
        }
        
        tabelview.reloadData()
    }
    
    func populateData() {
        let newTask = Items()
        newTask.name = self.textField.text!
        
        self.SaveData(newItem: newTask)
        
        tabelview.reloadData()
    }
    
    func loadData() {
        taskArray = selectedCategory?.todoItem.sorted(byKeyPath: "name", ascending: true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabelview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Marker Felt", size: 18)
        
        if let task = taskArray?[indexPath.row] {
            cell.textLabel?.text = task.name
            
            if taskArray?[indexPath.row].finish == true {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        else {
            cell.textLabel?.text = "Add a new task"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let task = taskArray?[indexPath.row] {
            do {
                try realm.write {
                    task.finish = !task.finish
                }
            }
            catch {
                print("Error")
            }
        }
        
        tabelview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (contextualAction, view, actionPerformed: (Bool) -> ()) in
            if let task = taskArray?[indexPath.row] {
                
                do {
                    try realm.write {
                        realm.delete(task)
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

    
}
