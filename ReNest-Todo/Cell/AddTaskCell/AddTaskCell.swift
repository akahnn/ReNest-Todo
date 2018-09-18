//
//  AddTaskCell.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/12/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit
import Spring

protocol AddTaskCellDelegate {
    func addTask(priority: NSInteger, indexPath: NSInteger)
}

class AddTaskCell: UITableViewCell {

    @IBOutlet var taskView: UIView!
    @IBOutlet var addBtn: SpringButton!
    @IBOutlet var taskLabel: SpringLabel!

    var priorityViewsContainer = SpringView()
    var priorityBtn = UIButton()

    var addTaskDelegate: AddTaskCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.white
        taskView.layer.cornerRadius = Constants.CornerRadius.Cell
        taskView.layer.masksToBounds = true
        addPriorityViews()
    }

    @objc func priorityBtnTapped(_ sender: UIButton) {
        slideOut()
        addBtn.isSelected = false
        self.addTaskDelegate?.addTask(priority: sender.tag, indexPath: self.addBtn.tag)
    }

    func slideIn() {
        addBtn.curve = "easeInOut"
        addBtn.rotate = 180
        addBtn.opacity = 0.4
        addBtn.animateTo()
        taskLabel.animation = "fadeOut"
        taskLabel.animate()
        priorityViewsContainer.animation = "fadeInRight"
        priorityViewsContainer.animate()
    }

    func slideOut() {
        addBtn.curve = "easeInOut"
        addBtn.rotate = 0
        addBtn.opacity = 1
        addBtn.animateTo()
        taskLabel.animation = "fadeIn"
        taskLabel.animate()
        priorityViewsContainer.animation = "fadeOut"
        priorityViewsContainer.x = -100
        priorityViewsContainer.animate()
    }

    @IBAction func addBtnPressed(_ sender: Any) {
        if addBtn.isSelected {
            slideOut()
            addBtn.isSelected = false
        }
        else {
            slideIn()
            addBtn.isSelected = true
        }
    }

    func addPriorityViews() {
        //define these or do them in xib
        var xCor = 14
        for i in 0..<3 {
            let priorityView = SpringView(frame: CGRect(x: xCor, y: 6, width: Int(92.5), height: 44))
            priorityView.backgroundColor = Priority.init(rawValue: i)?.color
            priorityView.layer.cornerRadius = Constants.CornerRadius.Cell
            priorityView.layer.masksToBounds = true

            xCor = xCor + Int(priorityView.frame.size.width) + 12

            var priorityText = Priority.init(rawValue: i)?.description
            priorityText = priorityText?.replacingOccurrences(of: " ", with: "\n")

            priorityBtn = UIButton(type: .custom)
            priorityBtn.setTitle(priorityText, for: .normal)
            priorityBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            priorityBtn.titleLabel?.font = UIFont.appBookFont(12.5)
            priorityBtn.titleLabel?.lineBreakMode = .byCharWrapping
            priorityBtn.titleLabel?.textAlignment = .center
            priorityBtn.tag = i
            priorityBtn.center = CGPoint(x: priorityView.bounds.size.width / 2, y: priorityView.bounds.size.height / 2)
            priorityBtn.addTarget(self, action: #selector(priorityBtnTapped), for: .touchUpInside)
            priorityView.addSubview(priorityBtn)

            priorityViewsContainer.frame = self.frame
            priorityViewsContainer.frame.size.width = 300
            priorityViewsContainer.alpha = 0
            priorityViewsContainer.addSubview(priorityView)
            taskView.addSubview(priorityViewsContainer)
        }

    }

}
