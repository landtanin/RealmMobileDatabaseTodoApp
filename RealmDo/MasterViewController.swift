//
//  MasterViewController.swift
//  RealmDo
//
//  Created by Tanin on 13/12/2017.
//  Copyright © 2017 landtanin. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {
    
    // Init Realm 1/3
    var realm : Realm!
    
    @IBOutlet var addBtn: UIBarButtonItem!
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    // init Realm 2/3, lazy-load the reminderList
    var remindersList: Results<Reminder> {
        get {
            return realm.objects(Reminder.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init Realm 3/3, instantiate Realm variable
        realm = try! Realm()
        
        // Do any additional setup after loading the view, typically from a nib.
//        navigationItem.leftBarButtonItem = editButtonItem
//
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @objc
//    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//    }
//
//    // MARK: - Segues
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {      // (4)
        return remindersList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = remindersList[indexPath.row]
        
        cell.textLabel!.text = item.name        // (5)
        cell.textLabel!.textColor = item.done == false ? UIColor.black : UIColor.lightGray
        
        return cell
        
    }

    // MARK: - Database Editing
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        let item = remindersList[indexPath.row]
        try! self.realm.write({     // (6), write new thing to database
            item.done = !item.done
        })
        
        //refresh rows
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete){
            let item = remindersList[indexPath.row]
            try! self.realm.write({
                self.realm.delete(item)     // (7), delete thing from database
            })
            
            tableView.deleteRows(at:[indexPath], with: .automatic)
            
        }
        
    }
    
    // MARK: - Add new reminder
    
    @IBAction func addReminder(_ sender: Any) {
        
        let alertVC : UIAlertController = UIAlertController(title: "New Reminder", message: "What do you want to remember?", preferredStyle: .alert)
        
        alertVC.addTextField { (UITextField) in
            
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        
        alertVC.addAction(cancelAction)
        
        //Alert action closure
        let addAction = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) -> Void in
            
            let textFieldReminder = (alertVC.textFields?.first)! as UITextField
            
            let reminderItem = Reminder()       // (8)
            reminderItem.name = textFieldReminder.text!
            reminderItem.done = false
            
            // We are adding the reminder to our database
            try! self.realm.write({
                self.realm.add(reminderItem)    // (9)
                
                self.tableView.insertRows(at: [IndexPath.init(row: self.remindersList.count-1, section: 0)], with: .automatic)
            })
            
        }
        
        alertVC.addAction(addAction)
        
        present(alertVC, animated: true, completion: nil)
        
    }
}

