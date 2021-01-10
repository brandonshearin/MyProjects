//
//  DataController.swift
//  MyProjects
//
//  Created by Brandon Shearin on 11/6/20.
//

import CoreData
import SwiftUI

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {
    
    // responsible for loading/managing local core data instances
    // and syncing with iCloud
    let container: NSPersistentCloudKitContainer
    
    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs.) Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false){
        container = NSPersistentCloudKitContainer(name: "Main")
        
        // for previewing/unit testing, we want our data to be stored in RAM and deleted when our app finishes running
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores{ _, error in
            
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("fatal error creating preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for projectCounter in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(projectCounter)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            
            for itemCounter in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(itemCounter)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
            }
        }
        
        try? viewContext.save()
          
    }
    
    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all our attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        // Make fetch request to get all `Item`
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        
        // Use batch delete request for all fetches items
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        // Make fetch request to get all `Project`
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        
        // Use batch delete request for all fetches projects
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        // wrap the try? in parens so that the compiler tries the fetch request, THEN nil coalesces
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            // returns true if they added a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        case "complete":
            // returns true if they completed a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        default:
            // an unknown award criterion, this should never be allowed
//            fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
}
