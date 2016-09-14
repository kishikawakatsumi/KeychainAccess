//
//  AccountsViewController.swift
//  Example
//
//  Created by kishikawa katsumi on 2014/12/25.
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

class AccountsViewController: UITableViewController {
    var itemsGroupedByService: [String: [[String: Any]]]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK:

    override func numberOfSections(in tableView: UITableView) -> Int {
        if itemsGroupedByService != nil {
            let services = Array(itemsGroupedByService!.keys)
            return services.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let services = Array(itemsGroupedByService!.keys)
        let service = services[section]

        let items = Keychain(service: service).allItems()
        return items.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let services = Array(itemsGroupedByService!.keys)
        return services[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let services = Array(itemsGroupedByService!.keys)
        let service = services[indexPath.section]

        let items = Keychain(service: service).allItems()
        let item = items[indexPath.row]

        cell.textLabel?.text = item["key"] as? String
        cell.detailTextLabel?.text = item["value"] as? String

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let services = Array(itemsGroupedByService!.keys)
        let service = services[indexPath.section]

        let keychain = Keychain(service: service)
        let items = keychain.allItems()

        let item = items[indexPath.row]
        let key = item["key"] as! String

        keychain[key] = nil

        if items.count == 1 {
            reloadData()
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK:

    func reloadData() {
        let items = Keychain.allItems(.genericPassword)
        itemsGroupedByService = groupBy(items) { item -> String in
            if let service = item["service"] as? String {
                return service
            }
            return ""
        }
    }
}

private func groupBy<C: Collection, K: Hashable>(_ xs: C, key: (C.Iterator.Element) -> K) -> [K:[C.Iterator.Element]] {
    var gs: [K:[C.Iterator.Element]] = [:]
    for x in xs {
        let k = key(x)
        var ys = gs[k] ?? []
        ys.append(x)
        gs.updateValue(ys, forKey: k)
    }
    return gs
}
