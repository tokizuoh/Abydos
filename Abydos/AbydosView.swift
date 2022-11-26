//
//  AbydosView.swift
//  Abydos
//
//  Created by tokizo on 2022/11/07.
//

import SwiftUI

struct AbydosView: View {
    //    @NSApplicationDelegateAdaptor(AppDelegate.self)
    //    private var delegate

    var body: some View {
        EmptyView()
    }
}

struct SettingsView: View {
    @State var text: String = ""
    @State var hoge: Bool = false

    var body: some View {
        VStack {
            Form {
                TextField("Hoge", text: $text)
                Toggle("hoge", isOn: $hoge)
            }
        }
        .padding(20)
    }
}
