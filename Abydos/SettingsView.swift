//
//  SettingsView.swift
//  Abydos
//
//  Created by tokizo on 2022/11/07.
//

import SwiftUI

struct SettingsView: View {
    @State var targetTag = ""
    @State var connectButtonDisabled = true

    var body: some View {
        VStack(alignment: .leading) {
            Form {
                TextField("Target Tag:", text: $targetTag)
            }
            .onChange(of: targetTag) { newValue in
                connectButtonDisabled = newValue.isEmpty
            }
            HStack {
                Spacer()
                Button(action: {}) {
                    Text("Cancel")
                }
                Button(action: {}) {
                    Text("Connect")
                }
                .disabled(connectButtonDisabled)
            }
        }
        .padding(20)
    }
}

#if DEBUG
struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
