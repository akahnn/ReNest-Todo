//
//  AllTasksViewController.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/12/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit
import CoreData

enum Priority: Int {

    case High = 0
    case Normal = 1
    case Low = 2

    var description: String {
        switch self {
        case .Low:
            return "Low Priority"
        case .Normal:
            return "Normal Priority"
        case .High:
            return "High Priority"
        }
    }

    var color: UIColor {
        switch self {
        case .Low:
            return UIColor.AppColor.Priority.Low!
        case .Normal:
            return UIColor.AppColor.Priority.Normal!
        case .High:
            return UIColor.AppColor.Priority.High!
        }
    }
}

let taskCellHeight = 83
let headerViewHeight = 50

class AllTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK: - Fetch Controllers
    var resultsController: NSFetchedResultsController<Task>!
    var searchResultsController: NSFetchedResultsController<Task>!
    var completedResultsController: NSFetchedResultsController<Task>!

    // MARK: - Properties
    @IBOutlet var completedBtn: UIButton!
    @IBOutlet var tasksBtn: UIButton!
    @IBOutlet var segmentIndicatorView: UIView!
    @IBOutlet var tableView: UITableView!

    var managedContext = CoreDataStack().managedContext
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Action Handlers
    @objc func addBtnPressed() {

        self.performSegue(withIdentifier: "ShowAddTask", sender: self)

    }

    @objc func menuBtnPressed() { }

    @IBAction func completedBtnPressed(_ sender: Any) {

        if tasksBtn.isSelected {
            tasksBtn.isSelected = false
            completedBtn.isSelected = true
            fetchCompletedTasks()
        }

        UIView.animate(withDuration: 0.5, animations: {
            let frame = self.segmentIndicatorView.frame
            self.segmentIndicatorView.frame = CGRect(x: self.completedBtn.frame.origin.x, y: frame.origin.y, width: 75, height: frame.size.height)

        }, completion: nil)

    }

    @IBAction func taskBtnPressed(_ sender: Any) {

        if completedBtn.isSelected {
            tasksBtn.isSelected = true
            completedBtn.isSelected = false
            fetchTasks()
        }

        UIView.animate(withDuration: 0.5, animations: {
            let frame = self.segmentIndicatorView.frame
            self.segmentIndicatorView.frame = CGRect(x: self.tasksBtn.frame.origin.x, y: frame.origin.y, width: 33, height: frame.size.height)

        }, completion: nil)

    }

    @objc func doneBtnTapped(_ sender: UIButton) {

        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath: NSIndexPath = self.tableView.indexPathForRow(at: buttonPosition)! as NSIndexPath

        let task = resultsController.object(at: indexPath as IndexPath)
        task.completed = true

        do {
            try managedContext.save()
            fetchTasks()
            fetchCompletedTasks()
        } catch {
            print("Error saving task: \(error)")
        }

    }

    // MARK: - Overrides
    
    override func viewDidAppear(_ animated: Bool) {

        fetchTasks()
        fetchCompletedTasks()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib.init(nibName: "TaskCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TaskCell")

        setUI()
        setNavBar()

    }

    // MARK: - Init

    func setUI() {

        tasksBtn.isSelected = true
        self.tableView.backgroundColor = UIColor.AppColor.App.Background
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none

    }

    func setNavBar() {

        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        // -- Setup the Navigation Bar --
        navigationController?.navigationBar.barTintColor
            = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu"), style: .plain, target: self, action: #selector(menuBtnPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Add"), style: .plain, target: self, action: #selector(addBtnPressed))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.AppColor.App.Icon
        navigationItem.rightBarButtonItem?.tintColor = UIColor.AppColor.App.Icon

        let searchBar = navigationItem.searchController?.searchBar
        searchBar?.searchBarStyle = .default

        if let textfield = searchBar?.value(forKey: "searchField") as? UITextField {

            UISearchBar.appearance().setImage(UIImage(named: "Search"), for: .search, state: .normal)

            textfield.layer.cornerRadius = 18;
            textfield.layer.masksToBounds = true

            textfield.font = UIFont(name: "Avenir-Book", size: 14)!

            textfield.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 14)!, NSAttributedStringKey.foregroundColor: UIColor.AppColor.App.SearchText!])

        }

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Avenir-Book", size: 14)!, NSAttributedStringKey.foregroundColor: UIColor.AppColor.Segment.Selected!], for: .normal)


        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir-Black", size: 19)!, NSAttributedStringKey.foregroundColor: UIColor.AppColor.App.ReNestPurple!]

    }


    //MARK: - CoreData

    func fetchCompletedTasks() {

        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "title", ascending: true)
        let predicate = NSPredicate(format: "completed == %@", NSNumber(booleanLiteral: true))

        request.sortDescriptors = [sortDescriptors]
        request.predicate = predicate
        completedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        completedResultsController.delegate = self

        do {
            try completedResultsController.performFetch()
            tableView.reloadDataAnimated()
        } catch {
            print("Perform fetch error: \(error)")
        }

    }
    
    
    func fetchTasks() {

        resultsController = nil

        // Request
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "priority", ascending: true)
        let predicate = NSPredicate(format: "completed == %@", NSNumber(booleanLiteral: false))

        // Init
        request.sortDescriptors = [sortDescriptors]
        request.predicate = predicate
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedContext,
            sectionNameKeyPath: "priority",
            cacheName: nil
        )
        resultsController.delegate = self

        do {
            try resultsController.performFetch()
            tableView.reloadDataAnimated()
        } catch {
            print("Perform fetch error: \(error)")
        }

    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: headerViewHeight))

        //Add Gradient
        let layer = CAGradientLayer()
        layer.frame = view.frame
        layer.colors = [UIColor.AppColor.App.ReNestPurple!.cgColor, UIColor.AppColor.App.Background!.cgColor]
        layer.opacity = 0.04
        view.layer.addSublayer(layer)

        //Add Header Title
        if isFiltering() || tasksBtn.isSelected {
            let headerTitle = UILabel(frame: CGRect(x: 25, y: -20, width: 200, height: 100))
            headerTitle.font = UIFont(name: "Avenir-Medium", size: 12)

            var indexTitle = resultsController.sectionIndexTitles[section]
            if isFiltering() { indexTitle = searchResultsController.sectionIndexTitles[section] }

            let priorityIndex: Int? = Int(indexTitle)

            headerTitle.textColor = Priority.init(rawValue: priorityIndex!)?.color
            let headerText = Priority.init(rawValue: priorityIndex!)?.description as NSString?
            headerTitle.text = headerText?.uppercased
            view.addSubview(headerTitle)
        }

        return view
    }

    func numberOfSections(in tableView: UITableView) -> Int {

        if isFiltering() {
            return searchResultsController?.sections?.count ?? 0
        } else if tasksBtn.isSelected {
            return resultsController?.sections?.count ?? 0
        } else if completedBtn.isSelected {
            return completedResultsController?.sections?.count ?? 0
        }

        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return searchResultsController.sections?[section].numberOfObjects ?? 0
        } else if tasksBtn.isSelected {
            return resultsController.sections?[section].numberOfObjects ?? 0
        } else if completedBtn.isSelected {
            return completedResultsController.sections?[section].numberOfObjects ?? 0
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell

        let task: Task

        cell.taskLabel.textColor = UIColor.AppColor.App.ReNestPurple
        cell.doneButton.tag = indexPath.row
        cell.doneButton.isSelected = false
        cell.doneButton.isUserInteractionEnabled = true

        if isFiltering() {
            task = searchResultsController.object(at: indexPath)
            cell.taskLabel.text = task.title
        }
        else if tasksBtn.isSelected {
            task = resultsController.object(at: indexPath)
            cell.taskLabel.text = task.title
        } else if completedBtn.isSelected {

            task = completedResultsController.object(at: indexPath)

            cell.taskLabel.textColor = UIColor.AppColor.App.TaskCompleted

            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: task.title!)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.taskLabel.attributedText = attributeString

            cell.doneButton.isSelected = true
            cell.doneButton.isUserInteractionEnabled = false

        }

        cell.doneButton.addTarget(self, action: #selector(doneBtnTapped), for: .touchUpInside)

        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(taskCellHeight)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if (completedBtn.isSelected) {
            return 15
        } else {
            return CGFloat(headerViewHeight)
        }

    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "ShowAddTask") {
            let vc = segue.destination as? AddTaskViewController
            vc?.managedContext = managedContext
        }

    }

    // MARK: - Private instance methods

    func filterContentForSearchText(_ searchText: String) {

        let text = searchController.searchBar.text

        if (text?.isEmpty)! {
            tableView.reloadData()
        } else {

            segmentIndicatorView.isHidden = true

            let request: NSFetchRequest<Task> = Task.fetchRequest()
            let sortDescriptors = NSSortDescriptor(key: "title", ascending: true)
            let predicate = NSPredicate(format: "title CONTAINS[c] %@ && completed == %@", text!, NSNumber(booleanLiteral: false))

            request.sortDescriptors = [sortDescriptors]
            request.predicate = predicate
            searchResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: managedContext,
                sectionNameKeyPath: "priority",
                cacheName: nil
            )
            searchResultsController.delegate = self

            do {
                try searchResultsController.performFetch()
                self.tableView.reloadData()
            } catch {
                print("Perform fetch error: \(error)")
            }
        }

    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }

}


