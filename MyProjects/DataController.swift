//
//  DataController.swift
//  MyProjects
//
//  Created by Brandon Shearin on 11/6/20.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    
    // responsible for loading/managing local core data instances
    // and syncing with iCloud
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false){
        container = NSPersistentCloudKitContainer(name: "Main")
        
        // for previewing/unit testing, we want our data to be stored in RAM and deleted
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores{ storeDescription, error in
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
        
        for i in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            
            for j in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
            }
        }
        
        try? viewContext.save()
          
    }
    
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
}