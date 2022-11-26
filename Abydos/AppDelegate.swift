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

    private var timeInterval: TimeInterval {
        #if DEBUG
        return 5
        #else
        return 3600
        #endif
    }
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

        Task {
            await fetchAndDispatch()
        }

        scheduleTimer(timeInterval)
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

        let menu: NSMenu = {
            let menu = NSMenu()
            menu.addItem(
                withTitle: NSLocalizedString("Open Scrapbox", comment: "Open Scrapbox page"),
                action: #selector(openScrapboxPage),
                keyEquivalent: ""
            )
            menu.addItem(
                withTitle: NSLocalizedString("Preference", comment: "Open Preference"),
                action: #selector(openPreference),
                keyEquivalent: ""
            )
            menu.addItem(.separator())
            menu.addItem(
                withTitle: NSLocalizedString("Quit", comment: "Quit app"),
                action: #selector(terminate),
                keyEquivalent: ""
            )
            return menu
        }()
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

    @objc private func openPreference() {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func fetchAndDispatch() async {
        do {
            let response = try await client.fetch()
            DispatchQueue.main.async { [weak self] in
                self?.statusItemModel = Translator.translate(response)
            }
        } catch {
            print(error)
        }
    }

    private func scheduleTimer(_ timeInterval: TimeInterval) {
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            Task { [weak self] in
                await self?.fetchAndDispatch()
            }
        }
    }
}
