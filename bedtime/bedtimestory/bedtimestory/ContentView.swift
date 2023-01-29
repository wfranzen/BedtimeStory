//
//  ContentView.swift
//  bedtimestory
//
//  Created by Tarun  on 1/29/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
        NavigationLink {
            RecordingView(newBookID: 9462)
        } label: {
            Label("Book 1", systemImage: "folder")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
