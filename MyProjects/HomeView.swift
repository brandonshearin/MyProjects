//
//  HomeView.swift
//  MyProjects
//
//  Created by Brandon Shearin on 11/6/20.
//

import CoreData
import SwiftUI

struct HomeView: View {
    
    static let tag: String? = "Home"
    
    @EnvironmentObject var dataController: DataController
    
    // this property wrapper will match ALL entities that you ask for (in this case Projects), in the sort order and filtered by the predicate you've given
    @FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)], predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>
    
    let items: FetchRequest<Item>
    
    init() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate,openPredicate])
        
        request.predicate = compoundPredicate
            
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.priority, ascending: false)
        ]
        // give me JUST 10 items
        request.fetchLimit = 10
        items = FetchRequest(fetchRequest: request)
        
    }
    
    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(projects, content: ProjectSummaryView.init)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.horizontal,.top])
                    }
                    
                    VStack(alignment: .leading) {
                        ItemListView(title:"Up next", items: items.wrappedValue.prefix(3))
                        ItemListView(title:"More to explore", items: items.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationBarTitle("Home")
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
            HomeView()
    }
}
