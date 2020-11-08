//
//  ContentView.swift
//  MyProjects
//
//  Created by Brandon Shearin on 11/6/20.
//

import SwiftUI

struct ContentView: View {
    
    // SceneStorage is better to use here than AppStorage because on iPad OS, if we had the app open side by side, AppStorage would store this value in the selectedView key and it would be attached to both instances of the application running.  We really just want it to be attached to a single instance, so use SceneStorage instead
    @SceneStorage("selectedView") var selectedView: String?
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ProjectView(showClosedProjects: false)
                .tag(ProjectView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }
            
            ProjectView(showClosedProjects: true)
                .tag(ProjectView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
