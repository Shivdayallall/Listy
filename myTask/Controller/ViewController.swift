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
    
    // create array of item object
    var taskArray = [Items]()
    // must make this a lazy var or app will crash with migration issue
    lazy var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabelview.delegate = self
        tabelview.dataSource = self
        searchTF.delegate = self
        
        // print realm file path
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    @IBAction func textfield(_ sender: UITextField) {
    }

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
        // add new item to end of task array
        let newTask = Items()
        newTask.name = searchTF.text!
        self.taskArray.append(newTask)
        self.SaveData(newItem: newTask)
        
        // reload tableview to show the new item that was added
        tabelview.reloadData()
    }
    
    // Delete item from task array
    func deleteData() {
        
    }
    
}

//MARK: - Configure the textfield
extension ViewController: UITextFieldDelegate {
    
    // **** Used IQKeyboardManager libary to controlled the keyboard ****
    
    // This method will ask the delegate if the return btn should be process
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTF.endEditing(true)
        
        populateData()
        
        return true
    }
    
    
}

//MARK: - Configure the tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabelview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.textLabel?.text = taskArray[indexPath.row].name
        
        if taskArray[indexPath.row].finish == true {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* Another way
            taskArray[indexPath.row].finish = ! taskArray[indexPath.row].finish
         */
        
        if taskArray[indexPath.row].finish == false {
            taskArray[indexPath.row].finish = true
        }
        else {
            taskArray[indexPath.row].finish = false
        }
        
        tabelview.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            taskArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(indexPath.item)
        }
    }
    
    
}



