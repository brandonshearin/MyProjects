//
//  Project-CoreDataHelpers.swift
//  MyProjects
//
//  Created by Brandon Shearin on 11/8/20.
//

import Foundation

extension Project {
    
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
    
    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }
    
    var projectItems: [Item] {
        let itemsArray = items?.allObjects as? [Item] ?? []
        return itemsArray
    }
    
    var projectItemsDefaultSorted: [Item] {
        return projectItems.sorted { first, second in
            // sort by completion status
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }
            
            // if you're still here, sort by priority
            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }
            
            // at this point, the items have same completion status and priority.  Tie breaker
            return first.itemCreationDate < second.itemCreationDate
        }
    }
    
    func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            return projectItems.sorted { $0.itemTitle < $1.itemTitle
            }
        case .creationDate:
            return projectItems.sorted {
                $0.itemCreationDate < $1.itemCreationDate
            }
        case .optimized:
            return projectItemsDefaultSorted
        }
    }
    
    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else {return 0}
        
        let completedItems = originalItems.filter { $0.completed == true}
        
        return Double(completedItems.count) / Double(originalItems.count)
    }
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let project = Project(context: viewContext)
        project.title = "Example project"
        project.detail = "this is an example project"
        project.closed = true
        project.creationDate = Date()
        
        try? viewContext.save()
        
        return project
    }
   
}
