//
//  AllTasksViewController.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/12/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit
import Spring
import CoreData

class AllTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK: - Fetch Controllers
     private var resultsController: NSFetchedResultsController<Task>!
     private var completedResultsController: NSFetchedResultsController<Task>!
     private var searchResultsController: NSFetchedResultsController<Task>!

    // MARK: - Properties
    @IBOutlet private var tasksBtn: UIButton!
    @IBOutlet private var completedBtn: UIButton!
    @IBOutlet private var segmentIndicatorView: SpringView!
    @IBOutlet private var tableView: UITableView!

    private var managedContext = CoreDataStack().managedContext
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Action Handlers
    @objc func addBtnPressed() {
        self.performSegue(withIdentifier: Constants.SegueIdentifiers.AddTask, sender: self)
    }

    @objc func menuBtnPressed() { }

    @IBAction func completedBtnPressed(_ sender: Any) {
        if tasksBtn.isSelected {
            tasksBtn.isSelected = false
            animateIndicatorView(button: completedBtn)
            fetchCompletedTasks()
        }
    }

    @IBAction func taskBtnPressed(_ sender: Any) {
        if completedBtn.isSelected {
            completedBtn.isSelected = false
            animateIndicatorView(button: tasksBtn)
            fetchTasks()
        }
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
    
    override func viewDidDisappear(_ animated: Bool) {
//        resultsController = nil
//        completedResultsController.dein
//        searchResultsController = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib.init(nibName: Constants.CellIdentifiers.Task, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.CellIdentifiers.Task)
        setUI()
        setNavBar()
        setSearchBar()
    }

    // MARK: - Init
    func setUI() {
        tasksBtn.isSelected = true
        self.tableView.backgroundColor = UIColor.AppColor.App.Background
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    func setSearchBar() {
        
        // -- Setup Search Controller --
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let searchBar = navigationItem.searchController?.searchBar
        searchBar?.searchBarStyle = .default
        if let textfield = searchBar?.value(forKey: "searchField") as? UITextField {
            UISearchBar.appearance().setImage(UIImage.Search(), for: .search, state: .normal)
            textfield.layer.cornerRadius = 18;
            textfield.layer.masksToBounds = true
            textfield.font = UIFont.appBookFont(14)
            textfield.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedStringKey.font: UIFont.appBookFont(14)!, NSAttributedStringKey.foregroundColor: UIColor.AppColor.App.SearchText!])
        }
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey.font: UIFont.appBookFont(14)!, NSAttributedStringKey.foregroundColor: UIColor.AppColor.Segment.Selected!], for: .normal)
        
    }
    
    func setNavBar() {
        // -- Setup Navigation Bar --
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.appBlackFont(19)!, NSAttributedStringKey.foregroundColor: UIColor.AppColor.App.ReNestPurple!]

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.Menu(), style: .plain, target: self, action: #selector(menuBtnPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.Add(), style: .plain, target: self, action: #selector(addBtnPressed))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.AppColor.App.Icon
        navigationItem.rightBarButtonItem?.tintColor = UIColor.AppColor.App.Icon
    }

    //MARK: - CoreData
    func fetchCompletedTasks() {
        if (completedResultsController == nil) {
            completedResultsController = self.resultsController(request: Task.completedFetchRequest, sectionNameKeyPath: nil) as! NSFetchedResultsController<Task>
            completedResultsController.delegate = self
        }
        do {
            try completedResultsController.performFetch()
            tableView.reloadDataAnimated()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }

    func fetchTasks() {
        if (resultsController == nil) {
            resultsController = self.resultsController(request: Task.incompletedFetchRequest, sectionNameKeyPath: "priority") as! NSFetchedResultsController<Task>
            resultsController.delegate = self
        }
        do {
            try resultsController.performFetch()
            tableView.reloadDataAnimated()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(Constants.HeaderHeight.WithTitle)))
        view.applyGradient(colours: [UIColor.AppColor.App.ReNestPurple!, UIColor.AppColor.App.Background!], alpha: 0.04)

        if isFiltering() || tasksBtn.isSelected {

            var titleIndex = resultsController.sectionIndexTitles[section]
            if isFiltering() {
                titleIndex = searchResultsController.sectionIndexTitles[section]
            }

            let priorityTitleIndex: Int? = Int(titleIndex)
            let headerText = Priority.init(rawValue: priorityTitleIndex!)?.description as NSString?
            
            let headerTitle = UILabel(frame: Constants.sectionViewHeaderTitleFrame)
            headerTitle.font = UIFont.appMediumFont(12)
            headerTitle.textColor = Priority.init(rawValue: priorityTitleIndex!)?.color
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
        let task: Task
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.Task) as! TaskCell
        cell.taskLabel.textColor = UIColor.AppColor.App.ReNestPurple
        cell.doneButton.isSelected = false
        cell.doneButton.isUserInteractionEnabled = true
        cell.doneButton.addTarget(self, action: #selector(doneBtnTapped), for: .touchUpInside)

        if isFiltering() {
            task = searchResultsController.object(at: indexPath)
            cell.taskLabel.text = task.title
        }
        else if tasksBtn.isSelected {
            task = resultsController.object(at: indexPath)
            cell.taskLabel.text = task.title
        }
        else if completedBtn.isSelected {
            task = completedResultsController.object(at: indexPath)
            cell.taskLabel.textColor = UIColor.AppColor.App.TaskCompleted
            cell.taskLabel.attributedText = task.title!.strikeThrough()
            cell.doneButton.isSelected = true
            cell.doneButton.isUserInteractionEnabled = false
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.CellHeight.Task
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (completedBtn.isSelected) {
            return Constants.HeaderHeight.WithOutTitle
        }
        else {
            return Constants.HeaderHeight.WithTitle
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.SegueIdentifiers.AddTask) {
            let vc = segue.destination as? AddTaskViewController
            vc?.managedContext = managedContext
        }
    }

    // MARK: - Private instance methods
    func filterContentForSearchText(_ searchText: String) {

        let text = searchController.searchBar.text

        if (text?.isEmpty)! {
            tableView.reloadData()
        }
        else {
            segmentIndicatorView.isHidden = true

            let request: NSFetchRequest<Task> = Task.sortedFetchRequest
            request.predicate = NSPredicate(format: "title CONTAINS[c] %@ && completed == %@", text!, NSNumber(booleanLiteral: false))
            searchResultsController = self.resultsController(request: request, sectionNameKeyPath: "priority") as! NSFetchedResultsController<Task>
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

    func resultsController(request: NSFetchRequest<Task>, sectionNameKeyPath: String?) -> NSFetchedResultsController<NSFetchRequestResult> {

        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedContext,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: nil
        ) as! NSFetchedResultsController<NSFetchRequestResult>
    }
    
    func animateIndicatorView(button: UIButton) {
        button.isSelected = true
        segmentIndicatorView.curve = "easeIn"
        segmentIndicatorView.duration = 0.8
        segmentIndicatorView.x = button.frame.origin.x - 12
        segmentIndicatorView.frame.size.width = (button.titleLabel?.text?.textWidth(font: UIFont.appHeavyFont(13)))! + 2
        segmentIndicatorView.animateTo()
    }

}
