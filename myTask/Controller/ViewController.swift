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
    @IBOutlet weak var searchTF: UITextField!
    
    // create array of item object, if you want to do it without realm just used the array of item of object inteam of result container
    // var taskArray = [Items]()
    
    // taskArray is now of data type results to match realm data object
    // var taskArray: Results<Items>!
    
    // must be an optional b/c force unwraping is bad habit, Results is a realm data type. must make variable type of relam
    var taskArray: Results<Items>?

    
    // must make this a lazy var or app will crash with migration issue
    lazy var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tabelview.delegate = self
        tabelview.dataSource = self
        searchTF.delegate = self
        
        // Load data
        loadData()
        
        // print realm file path
       //  print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    //MARK: - C in crud. this function take in a paramater that is type Items fron the Items class
    func SaveData(newItem: Items) {
        do {
            try  realm.write {
                realm.add(newItem)
            }
        }
        catch  {
                print("Error saving \(Error.self)")
            }
            tabelview.reloadData()
        }
    
    // Add items to words array
    func populateData() {
        let newTask = Items()
        newTask.name = searchTF.text!
        
        // dont need to append b/c realm will auto update data
        //  self.taskArray.append(newTask)
        
        self.SaveData(newItem: newTask)
        // tabelview.scrollToRow(at: indexPath , at: .bottom, animated: true)

        
        // reload tableview to show the new item that was added
        tabelview.reloadData()
    }
    
    //MARK: - R in crud. Load data from realm db.
    func loadData() {
        taskArray = realm.objects(Items.self)
    }
    
}

//MARK: - Configure the textfield
extension ViewController: UITextFieldDelegate {
    
    // **** Used IQKeyboardManager libary to controlled the keyboard ****
    
    // This method will ask the delegate if the return btn should be process
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTF.endEditing(true)
        
        populateData()
        
        // clear textfield
        searchTF.text = ""
        
        return true
    }
    
    
}

//MARK: - Configure the tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // nil cosleasing operator, if task is nil or empty returnn 1 cell if not return the count
        return taskArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabelview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
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
            cell.textLabel?.text = "Task not added"
        }
            
        return cell
    }
    
    //MARK: - U in crud. update the view when user click on cell.
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
    
    //MARK: - D in crud. delete user task when swipe on cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            
            if let task = taskArray?[indexPath.row] {
                
                do {
                    try realm.write {
                        realm.delete(task)
                    }
                }
                catch {
                    print("Item not deleted")
                }
            }
            
        } // close .delete
        
        tabelview.reloadData()
        
    } // close tableview function
    
}



