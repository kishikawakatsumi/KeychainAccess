//
//  AccountsViewController.swift
//  Example
//
//  Created by kishikawa katsumi on 2014/12/25.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

import UIKit
import KeychainAccess

class AccountsViewController: UITableViewController {
    
    var services: [String: [[String: AnyObject]]]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if services != nil {
            return services!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let service = Array(services!.keys)[section]
        if let items = Keychain.allItems(service:service) {
            return items.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let service = Array(services!.keys)[section]
        return service
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        let service = Array(services!.keys)[indexPath.section]
        if let items = Keychain.allItems(service:service) {
            let item = items[indexPath.row]
            cell.textLabel?.text = item["key"] as? String
            cell.detailTextLabel?.text = item["value"] as? String
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let service = Array(services!.keys)[indexPath.section]
        if let items = Keychain.allItems(service:service) {
            let item = items[indexPath.row]
            let key = item["key"] as String
            
            Keychain.remove(key, service: service)
            
            if items.count == 1 {
                reloadData()
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }
    
    // MARK:
    
    func reloadData() {
        let items = Keychain.allItems()
        if items != nil {
            services = groupBy(items!) { item -> String in
                let service = item["service"] as String
                return service
            }
        }
    }

}

func groupBy<C: CollectionType, K: Hashable>(xs: C, key: C.Generator.Element -> K) -> [K:[C.Generator.Element]] {
    var gs: [K:[C.Generator.Element]] = [:]
    for x in xs {
        let k = key(x)
        var ys = gs[k] ?? []
        ys.append(x)
        gs.updateValue(ys, forKey: k)
    }
    return gs
}
