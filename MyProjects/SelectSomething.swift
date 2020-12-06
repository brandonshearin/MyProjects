//
//  SelectSomething.swift
//  MyProjects
//
//  Created by Brandon Shearin on 11/22/20.
//

import SwiftUI

struct SelectSomething: View {
    var body: some View {
        Text("Please select something from the menu to begin")
            .italic()
            .foregroundColor(.secondary)
    }
}

struct SelectSomething_Previews: PreviewProvider {
    static var previews: some View {
        SelectSomething()
    }
}
