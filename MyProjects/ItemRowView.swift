//
//  ItemRowView.swift
//  MyProjects
//
//  Created by Brandon Shearin on 11/8/20.
//

import SwiftUI

struct ItemRowView: View {
    
    // ObservedObject property wrapper watches some class that conforms to `ObservableObject.`  It is different from StateObject slightly, it means that someone else created this object
    @ObservedObject var project: Project
    @ObservedObject var item: Item
    
    var icon: some View {
        if item.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
        } else if item.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(project.projectColor))
        } else {
            // return an invisible image here because the label isn't smart and the layout will be jagged for rows that fall into this conditional block
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)){
            Label {
                Text(item.itemTitle)
            } icon: {
                icon
            }
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: Project.example, item: Item.example)
    }
}
