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
                    ContentRow(result: $0)
                }
            }
            .background(Color.offWhite)
            .neumorphicShadowBlack(radius: 10)
            .neumorphicShadowWhite(radius: 10)
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct ContentRow : View {
    var result: String
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        HStack {
            Image("m13")
            Text(result)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
