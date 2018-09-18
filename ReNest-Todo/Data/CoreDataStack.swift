//
//  CoreDataStack.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/12/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "ReNest_Todo")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
        }

        return container
    }

    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
}
