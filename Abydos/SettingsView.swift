//
//  SettingsView.swift
//  Abydos
//
//  Created by tokizo on 2022/11/07.
//

import SwiftUI

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

//#if DEBUG
//struct SettingsView_Preview: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
//
//#endif
