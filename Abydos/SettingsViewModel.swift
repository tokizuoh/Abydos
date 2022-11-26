//
//  SettingsViewModel.swift
//  Abydos
//
//  Created by tokizo on 2022/11/26.
//

import AppKit

final class SettingsViewModel: ObservableObject {
    @Published var targetTag = ""

    func cancel() {
        closeWindow()
    }

    func connect() {
        // TODO: call using api client
        closeWindow()
    }

    private func closeWindow() {
        _ = NSApplication.shared.windows.map { window in
            if "\(type(of: window))" == "AppKitWindow" {
                window.close()
            }
        }
    }
}
