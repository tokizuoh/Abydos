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

    let client = APIClient(
        url: Dummy.url,
        cookieKey: Dummy.key,
        cookieValue: Dummy.value
    )

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task {
                do {
                    guard let self else {
                        return
                    }
                    let response = try await self.client.fetch()
                    if let title = Translator.translate(response) {
                        self.statusItem.button?.title = "📗" + title
                    }
                } catch {
                    print(error)
                }
            }

        }

    }
}
