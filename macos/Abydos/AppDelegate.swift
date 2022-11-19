//
//  AppDelegate.swift
//  Abydos
//
//  Created by tokizo on 2022/11/19.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    let client = APIClient(
        url: Dummy.url,
        cookieKey: Dummy.key,
        cookieValue: Dummy.value
    )

    func applicationDidFinishLaunching(_ notification: Notification) {
        closeWindowIfOpened()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.action = #selector(showPopOver)
        }

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

    private func closeWindowIfOpened() {
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
    }

    @objc private func showPopOver(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent,
              (event.type == .leftMouseUp || event.type == .rightMouseUp )else {
            return
        }
        let menu = NSMenu()
        menu.addItem(
            withTitle: NSLocalizedString("Open Scrapbox", comment: "Open Scrapbox page"),
            action: #selector(openScrapboxPage),
            keyEquivalent: ""
        )
        menu.addItem(.separator())
        menu.addItem(
            withTitle: NSLocalizedString("Quit", comment: "Quit app"),
            action: #selector(terminate),
            keyEquivalent: ""
        )
        statusItem?.menu = menu
    }

    @objc func terminate() {
        NSApp.terminate(self)
    }

    @objc func openScrapboxPage() {
        // TODO: Scrapbox URL
        NSWorkspace.shared.open(URL(string: "https://google.com")!)
    }
}
