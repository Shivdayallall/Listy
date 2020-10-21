//
//  ViewController.swift
//  myTask
//
//  Created by shiv on 10/20/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tabelview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var taskArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabelview.delegate = self
        tabelview.dataSource = self
        searchTF.delegate = self
    }
    
    @IBAction func textfield(_ sender: UITextField) {
    }
    
    // Add items to words array
    func populateData() {
        
        // add new item to end of task array
        taskArray.append(searchTF.text!)
        
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // clear textfield after item is enter
    }
    
}

//MARK: - Configure the tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabelview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.textLabel?.text = taskArray[indexPath.row]
        
        return cell
    }
    
}


