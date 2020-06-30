//
//  ContentView.swift
//  MetroLines
//
//  Created by Chatharoo on 30/06/2020.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject var missionsViewModel = MissionsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.missionsViewModel.results, id: \.self) {
                    Text("\($0)")
                }
            }.listStyle(InsetGroupedListStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
