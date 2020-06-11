//
//  ViewController.swift
//  Tasks
//
//  Created by Apurva Deshmukh on 6/11/20.
//  Copyright © 2020 Apurva Deshmukh. All rights reserved.
//

import UIKit
import RealmSwift

/*
    - To show list of current to-do list items
    - To enter new to-do list items
    - To show previously entered to-do list items
 
    - Item
    - Date
 */

class TaskItem: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    
    private let realm = try! Realm()
    private var data = [TaskItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(TaskItem.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
    // Mark: Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Open the screen where we can see item info and delete
    }
    
    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "entry") as? EntryViewController else {
            return
        }
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "New Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh() {
        data = realm.objects(TaskItem.self).map({ $0 })
        table.reloadData()
    }
}
