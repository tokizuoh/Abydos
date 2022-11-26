//
//  SettingsViewModel.swift
//  Abydos
//
//  Created by tokizo on 2022/11/26.
//

import AppKit

final class SettingsViewModel: ObservableObject {
    @Published var includedTag = ""
    @Published var excludedTag = ""

    let inputDataCacher: InputDataCacher

    init(inputDataCacher: InputDataCacher) {
        self.inputDataCacher = inputDataCacher
        Task {
            includedTag = await inputDataCacher.getIncludedTag() ?? ""
            excludedTag = await inputDataCacher.getExcludedTag() ?? ""
        }
    }

    func cancel() {
        closeWindow()
    }

    func connect() {
        Task {
            await inputDataCacher.setIncludedTag(includedTag)
            await inputDataCacher.setExcludedTag(excludedTag)
        }
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
