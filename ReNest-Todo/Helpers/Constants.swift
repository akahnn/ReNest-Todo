//
//  Constants.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/14/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit

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

struct Constants {
    
    struct SegueIdentifiers {
        static let AddTask = "ShowAddTask"
    }
    
    struct CellIdentifiers {
        static let Task = "TaskCell"
        static let AddTask = "AddTaskCell"
    }
    
    struct CellHeight {
        static let Task : CGFloat = 82.0
        static let AddTask : CGFloat = 65.0
    }
    
    struct HeaderHeight {
        static let WithTitle : CGFloat = 50.0
        static let WithOutTitle : CGFloat = 15.0
    }
    
    struct CornerRadius {
        static let Cell : CGFloat = 5.0
    }
    
    static let sectionViewHeaderTitleFrame = CGRect(x: 25, y: -20, width: 200, height: 100)
   
    //UserDefaults
    static let TaskArrayKey = "TasksArray"
    
    //Default Data
    static let DefaultTasksArray = ["Book professional movers", "Prepare the house", "Review moving plans", "Prepare for payment", "Pack an essentials box", "Prepare appliances", "Measure furniture and doorways"]
   
}
