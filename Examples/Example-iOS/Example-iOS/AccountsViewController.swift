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
    var itemsGroupedByService: [String: [[String: AnyObject]]]?

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
        if itemsGroupedByService != nil {
            let services = Array(itemsGroupedByService!.keys)
            return services.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let services = Array(itemsGroupedByService!.keys)
        let service = services[section]
        
        let items = Keychain(service: service).allItems()
        return items.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let services = Array(itemsGroupedByService!.keys)
        return services[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        let services = Array(itemsGroupedByService!.keys)
        let service = services[indexPath.section]
        
        let items = Keychain(service: service).allItems()
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item["key"] as? String
        cell.detailTextLabel?.text = item["value"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let services = Array(itemsGroupedByService!.keys)
        let service = services[indexPath.section]
        
        let keychain = Keychain(service: service)
        let items = keychain.allItems()
        
        let item = items[indexPath.row]
        let key = item["key"] as! String
        
        keychain[key] = nil
        
        if items.count == 1 {
            reloadData()
            tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
        } else {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    // MARK:
    
    func reloadData() {
        let items = Keychain.allItems(.GenericPassword)
        itemsGroupedByService = groupBy(items) { item -> String in
            if let service = item["service"] as? String {
                return service
            }
            return ""
        }
    }
}

private func groupBy<C: CollectionType, K: Hashable>(xs: C, key: C.Generator.Element -> K) -> [K:[C.Generator.Element]] {
    var gs: [K:[C.Generator.Element]] = [:]
    for x in xs {
        let k = key(x)
        var ys = gs[k] ?? []
        ys.append(x)
        gs.updateValue(ys, forKey: k)
    }
    return gs
}
