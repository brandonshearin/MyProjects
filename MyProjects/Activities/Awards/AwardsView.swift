//
//  AwardsView.swift
//  MyProjects
//
//  Created by Brandon Shearin on 11/24/20.
//

import SwiftUI

struct AwardsView: View {
    
    static let tag: String? = "Awards"
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    @EnvironmentObject var dataController: DataController
    
    // making a default value will never be seen, so it will never seen.  This is a better placeholder than the alternative, which is making selectedAward optional
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards){ award in
                        Button {
                            // no action yet
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(dataController.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5))
                        }
                    }
                }
            }
            .navigationTitle("Awards")
        }
        .alert(isPresented: $showingAwardDetails) {
            if dataController.hasEarned(award: selectedAward) {
                return Alert(title: Text("Unlocked: \(selectedAward.name)"), message: Text(selectedAward.description), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Locked: \(selectedAward.name)"), message: Text(selectedAward.description), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
            .environmentObject(DataController.preview)
    }
}
