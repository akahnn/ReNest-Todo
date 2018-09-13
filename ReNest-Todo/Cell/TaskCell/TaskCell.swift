//
//  TaskCell.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/11/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit
import Spring

let CellRadius = 5.0

class TaskCell: UITableViewCell {

    @IBOutlet var doneButton: UIButton!
    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var taskView: SpringView!

    @IBAction func doneBtnTapped(_ sender: Any) {

        doneButton.isSelected = doneButton.isSelected ? false : true

    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.backgroundColor = UIColor.AppColor.App.Background
        taskView.layer.cornerRadius = CGFloat(CellRadius)
        taskView.layer.applySketchShadow(
            color: UIColor.AppColor.App.ShadowColor,
            alpha: 0.01,
            x: 0,
            y: 9,
            blur: 9,
            spread: 0)

    }

}
