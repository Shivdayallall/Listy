//
//  ViewController.swift
//  myTask
//
//  Created by shiv on 10/20/20.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tabelview: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    let words = ["clean room", "buy food", "vaccum"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabelview.delegate = self
        tabelview.dataSource = self
        searchTF.delegate = self
    }
    
    @IBAction func textfield(_ sender: UITextField) {
    }
    
    @IBAction func enterBtn(_ sender: UIButton) {
        print("tap")
    }
    
    
}

//MARK: - Configure the tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabelview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.textLabel?.text = words[indexPath.row]
        
        return cell
    }

    
}


