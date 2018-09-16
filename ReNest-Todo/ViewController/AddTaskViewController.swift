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

class AddTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTaskCellDelegate {

    @IBOutlet var tableView: UITableView!
    
    var defaults = UserDefaults.standard
    var taskArray: NSMutableArray = []
    var managedContext: NSManagedObjectContext!

    //MARK: - Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataSource()
        setUI()
        setNavBar()
    }
    
    func setDataSource() {
        if let array = defaults.object(forKey: Constants.TaskArrayKey) as? NSArray {
            taskArray =  array.mutableCopy() as! NSMutableArray
            tableView.reloadData()
        } else {
            addDefaultTasks()
        }
    }
    
    func setUI() {
        let nib = UINib.init(nibName: Constants.CellIdentifiers.AddTask, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.CellIdentifiers.AddTask)
        tableView.backgroundColor = UIColor.white
        tableView.isScrollEnabled = false
    }
    
    func setNavBar() {
        navigationItem.title = "Add Task";
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.appMediumFont(19)!, NSAttributedStringKey.foregroundColor: UIColor.AppColor.App.ReNestPurple!]
        navigationController?.navigationBar.backgroundColor = UIColor.white
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.Back(), style: .plain, target: self, action: #selector(backBtnPressed))
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
            defaults.set(taskArray, forKey: Constants.TaskArrayKey)
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

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.AddTask) as! AddTaskCell
        if let taskTitle = taskArray[indexPath.row] as? String {
            cell.taskLabel.text = taskTitle
        }
        cell.addBtn.tag = indexPath.row
        cell.addTaskDelegate = self
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.CellHeight.AddTask
    }
    
    // MARK: - Helper Methods
    
    func addDefaultTasks() {
        defaults.set(Constants.DefaultTasksArray, forKey: Constants.TaskArrayKey)
        defaults.synchronize()
        taskArray = NSMutableArray(array: Constants.DefaultTasksArray)
        self.tableView.reloadDataAnimated()
    }

}
