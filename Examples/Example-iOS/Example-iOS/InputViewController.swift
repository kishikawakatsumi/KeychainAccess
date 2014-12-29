//
//  InputViewController.swift
//  Example
//
//  Created by kishikawa katsumi on 2014/12/26.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

import UIKit
import KeychainAccess

class InputViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var serviceField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44.0
        tableView.estimatedRowHeight = 44.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveAction(sender: UIBarButtonItem) {
        let keychain = Keychain(service: serviceField.text)
        keychain[usernameField.text] = passwordField.text
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func editingChanged(sender: UITextField) {
        saveButton.enabled = !usernameField.text.isEmpty && !passwordField.text.isEmpty
    }

}
