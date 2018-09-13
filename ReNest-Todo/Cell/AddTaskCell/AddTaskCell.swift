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

    var priorityBtn = UIButton()
    var priorityViewContainer = SpringView()

    var addTaskDelegate: AddTaskCellDelegate?

    override func awakeFromNib() {

        super.awakeFromNib()

        self.backgroundColor = UIColor.white
        taskView.layer.cornerRadius = 5
        taskView.layer.masksToBounds = true
        addPriorityViews()

    }

    @objc func priorityBtnTapped(_ sender: UIButton) {

        self.priorityViewContainer.animation = "fadeOut"
        self.priorityViewContainer.x = -100
        self.priorityViewContainer.animateNext {
            self.addTaskDelegate?.addTask(priority: sender.tag, indexPath: self.addBtn.tag)
        }

        addBtn.curve = "easeInOut"
        addBtn.rotate = 0
        addBtn.opacity = 1
        addBtn.animateTo()

        addBtn.isSelected = false

        taskLabel.animation = "fadeIn"
        taskLabel.animate()
    }


    @IBAction func addBtnPressed(_ sender: Any) {

        if addBtn.isSelected {
            addBtn.curve = "easeInOut"
            addBtn.rotate = 0
            addBtn.opacity = 1
            addBtn.animateTo()

            addBtn.isSelected = false

            taskLabel.animation = "fadeIn"
            taskLabel.animate()

            self.priorityViewContainer.animation = "fadeOut"
            self.priorityViewContainer.x = -100
            self.priorityViewContainer.animate()

        } else {

            addBtn.curve = "easeInOut"
            addBtn.rotate = 180
            addBtn.opacity = 0.4
            addBtn.isSelected = true
            addBtn.animateTo()

            self.priorityViewContainer.animation = "fadeInRight"
            self.priorityViewContainer.animate()

            taskLabel.animation = "fadeOut"
            taskLabel.animate()
        }

    }

    func addPriorityViews() {

        var xCor = Int(22)
        for i in 0..<3 {

            let priorityView = SpringView(frame: CGRect(x: xCor, y: 6, width: Int(92.5), height: 44))
            priorityView.backgroundColor = Priority.init(rawValue: i)?.color
            priorityView.layer.cornerRadius = 5
            priorityView.layer.masksToBounds = true

            xCor = xCor + Int(priorityView.frame.size.width) + 12

            var priorityText = Priority.init(rawValue: i)?.description
            priorityText = priorityText?.replacingOccurrences(of: " ", with: "\n")

            priorityBtn = UIButton(type: .custom)
            priorityBtn.setTitle(priorityText, for: .normal)
            priorityBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            priorityBtn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 12.5)
            priorityBtn.titleLabel?.lineBreakMode = .byCharWrapping
            priorityBtn.titleLabel?.textAlignment = .center
            priorityBtn.tag = i
            priorityBtn.center = CGPoint(x: priorityView.bounds.size.width / 2, y: priorityView.bounds.size.height / 2)
            priorityBtn.addTarget(self, action: #selector(priorityBtnTapped), for: .touchUpInside)
            priorityView.addSubview(priorityBtn)

            priorityViewContainer.frame = self.frame
            priorityViewContainer.frame.size.width = 300
            priorityViewContainer.alpha = 0
            priorityViewContainer.addSubview(priorityView)
            taskView.addSubview(priorityViewContainer)
        }

    }

}
