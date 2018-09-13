//
//  AddTaskViewController.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/12/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit
import Spring
import CoreData

let addTaskCellHeight = 65

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTaskCellDelegate {

    @IBOutlet var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    var managedContext: NSManagedObjectContext!
    var taskArray: NSMutableArray = []
    
    //MARK: - Initialize
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setDataSource()
        setUI()
        setNavBar()
        
    }
    
    func setDataSource() {
        
        let array = defaults.object(forKey: "TasksArray") as? [String] ?? [String]()
        
        if (array.count == 0) {
            addDefaultTasks()
        } else {
            taskArray = NSMutableArray(array: array)
            tableView.reloadData()
        }
        
    }
    
    func setUI() {
        
        let nib = UINib.init(nibName: "AddTaskCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddTaskCell")
        tableView.backgroundColor = UIColor.white
        tableView.isScrollEnabled = false
        
    }
    
    func setNavBar() {
        
        navigationItem.title = "Add Task";
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 19)!, NSAttributedStringKey.foregroundColor: UIColor.AppColor.App.ReNestPurple!]
        navigationController?.navigationBar.backgroundColor = UIColor.white
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(backBtnPressed))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.AppColor.App.Icon
        
    }
    

    // MARK: - Action Handler
    
    @objc func backBtnPressed() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func addTask(priority: NSInteger, indexPath: NSInteger) {

        let task = Task(context: managedContext)
        task.title = taskArray[indexPath] as? String
        task.priority = Int16(priority)
        task.completed = false

        do {
            try managedContext.save()
            taskArray.removeObject(at: indexPath)
            defaults.set(taskArray, forKey: "TasksArray")
            defaults.synchronize()
            self.tableView.reloadDataAnimated()
        } catch {
            print("Error saving task: \(error)")
        }

    }


    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return taskArray.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskCell") as! AddTaskCell

        cell.addBtn.tag = indexPath.row
        cell.taskLabel.text = taskArray[indexPath.row] as? String
        cell.addTaskDelegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return CGFloat(addTaskCellHeight)

    }
    
    // MARK: - Helper Methods
    
    func addDefaultTasks() {
        
        let defaultTasks = ["Book professional movers", "Prepare the house", "Review moving plans", "Prepare for payment", "Pack an essentials box", "Prepare appliances", "Measure furniture and doorways"]
        
        defaults.set(taskArray, forKey: "TasksArray")
        defaults.synchronize()
        taskArray = NSMutableArray(array: defaultTasks)
        
        self.tableView.reloadDataAnimated()
        
    }

}
