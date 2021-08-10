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
    lazy var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabelview.delegate = self
        tabelview.dataSource = self
        
        loadData()
        
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { add in
            
            let item = Items()
            
            item.name = self.textField.text!.capitalized
            
            self.SaveData(newItem: item)
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        alert.addTextField { [self] field in
            self.textField = field
            textField.placeholder = "New Task"
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
        taskArray = realm.objects(Items.self)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            
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
        
        tabelview.reloadData()
        
    }
    
}
