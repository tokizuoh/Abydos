//
//  SettingsView.swift
//  Abydos
//
//  Created by tokizo on 2022/11/07.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject
    private var viewModel = SettingsViewModel(inputDataCacher: InputDataCacher.shared)

    @State
    private var connectButtonDisabled = true

    var body: some View {
        VStack(alignment: .leading) {
            Form {
                TextField("Included Tag:", text: $viewModel.includedTag)
                TextField("Excluded Tag:", text: $viewModel.excludedTag)
            }
            .onChange(of: viewModel.includedTag) { newValue in
                connectButtonDisabled = newValue.isEmpty
            }
            HStack {
                Spacer()
                Button(action: viewModel.cancel) {
                    Text("Cancel")
                }
                Button(action: viewModel.connect) {
                    Text("Connect")
                }
                .disabled(connectButtonDisabled)
            }
        }
        .padding(20)
        .navigationTitle("Abydos")
    }
}

#if DEBUG
// swiftlint:disable type_name
struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
// swiftlint:enable type_name
#endif
