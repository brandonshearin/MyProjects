//
//  EditProjectView.swift
//  MyProjects
//
//  Created by Brandon Shearin on 11/15/20.
//

import SwiftUI

struct EditProjectView: View {
    
    let project: Project
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingDeleteConfirm: Bool = false
    @State private var color: String
    @State private var title: String
    @State private var detail: String
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init(project: Project){
        self.project = project
        
        _color = State(wrappedValue: project.projectColor)
        _title = State(wrappedValue:project.projectTitle)
        _detail = State(wrappedValue:project.projectDetail)
    }
    
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }
    
    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        Form {
            // Section 1
            Section(header: Text("Basic settings")){
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            // Section 2
            Section(header: Text("Custom project color")){
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)
                            
                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            color = item
                            update()
                        }
                    }
                }
                .padding(.vertical)
            }
            // Section 3
            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project completely.")) {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    update()
                }
                
                Button("Delete this project") {
                    // delete the project
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .onDisappear(perform: dataController.save)
        .navigationBarTitle("Edit Project")
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete project?"),
                  message: Text("Are you sure you want to delete this project?"),
                  primaryButton: .default(Text("Delete"), action: delete), secondaryButton: .cancel())
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        NavigationView{
            EditProjectView(project: Project.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
