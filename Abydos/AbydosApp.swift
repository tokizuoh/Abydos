//
//  AbydosApp.swift
//  Abydos
//
//  Created by tokizo on 2022/11/07.
//

import SwiftUI

@main
struct AbydosApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    private var delegate

    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
        Settings {
            SettingsView()
        }
    }
}
