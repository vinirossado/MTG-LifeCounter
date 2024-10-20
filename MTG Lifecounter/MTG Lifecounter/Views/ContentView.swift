//
//  ContentView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 17.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .featured
    
    enum Tab {
        case featured
        case list
    }
    
    var body: some View {
        PlayerView(lifeTotal: .constant(20), playerImage: "player1", size: 200)
        //        TabView(selection: $selection) {
        //            Counter()
        //                .tabItem {
        //                    Label("Featured", systemImage: "star")
        //                }
        //                .tag(Tab.featured)
        //
        //            Counter()
        //                .tabItem {
        //                    Label("List", systemImage: "list.bullet")
        //                }
        //                .tag(Tab.list)
        //        }
        //    }
    }
}

#Preview {
    ContentView()
    
}
