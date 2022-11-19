//
//  ContentView.swift
//  Abydos
//
//  Created by tokizo on 2022/11/07.
//

import SwiftUI

struct ContentView: View {
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var delegate

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}
