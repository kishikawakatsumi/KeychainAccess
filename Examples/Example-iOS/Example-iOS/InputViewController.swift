//
//  InputViewController.swift
//  Example
//
//  Created by kishikawa katsumi on 2014/12/26.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAction(sender: UIBarButtonItem) {
        let keychain: Keychain
        if let service = serviceField.text, !service.isEmpty {
            keychain = Keychain(service: service)
        } else {
            keychain = Keychain()
        }
        keychain[usernameField.text!] = passwordField.text

        dismiss(animated: true, completion: nil)
    }

    @IBAction func editingChanged(sender: UITextField) {
        switch (usernameField.text, passwordField.text) {
        case let (username?, password?):
            saveButton.isEnabled = !username.isEmpty && !password.isEmpty
        case (_?, nil):
            saveButton.isEnabled = false
        case (nil, _?):
            saveButton.isEnabled = false
        case (nil, nil):
            saveButton.isEnabled = false
        }
    }

}
