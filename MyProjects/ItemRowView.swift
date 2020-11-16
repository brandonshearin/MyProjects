//
//  ItemRowView.swift
//  MyProjects
//
//  Created by Brandon Shearin on 11/8/20.
//

import SwiftUI

struct ItemRowView: View {
    
    // ObservedObject property wrapper watches some class that conforms to `ObservableObject.`  It is different from StateObject slightly, it means that someone else created this object
    @ObservedObject var item: Item
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)){
            Text(item.itemTitle)
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
            ItemRowView(item: Item.example)
    }
}
