//
//  AppDelegate.swift
//  Abydos
//
//  Created by tokizo on 2022/11/19.
//

import AppKit

struct StatusItemModel {
    let title: String
    let urlString: String
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private lazy var statusItemModel: StatusItemModel? = nil {
        didSet {
            guard let statusItemModel else {
                return
            }
            statusItem.button?.title = "📘 \(statusItemModel.title)"
        }
    }

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
                    self.statusItemModel = Translator.translate(response)
                } catch {
                    print(error)
                }
            }
        }
    }
}

// MARK: - Feature
private extension AppDelegate {
    private func closeWindowIfOpened() {
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
    }

    @objc private func showPopOver(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent,
              event.type == .leftMouseUp || event.type == .rightMouseUp else {
            return
        }
        var menu: NSMenu {
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
            return menu
        }
        statusItem?.menu = menu
    }

    @objc private func terminate() {
        NSApp.terminate(self)
    }

    @objc private func openScrapboxPage() {
        guard let statusItemModel,
              let url = URL(string: statusItemModel.urlString) else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}
