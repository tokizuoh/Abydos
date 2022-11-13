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

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    let titles = [
        "aaaaaa",
        "BBBBB",
        "yyyy",
        "DDD",
        "oo",
        "s"
    ]

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.statusItem.button?.title = "📗" + (self?.titles.randomElement() ?? "")
        }
    }
}
