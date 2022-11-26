//
//  InputDataCacher.swift
//  Abydos
//
//  Created by tokizo on 2022/11/26.
//

import SwiftUI

actor InputDataCacher {
    static var shared = InputDataCacher()

    private init() {}

    @AppStorage("includedTag") private var includedTag: String?
    @AppStorage("excludedTag") private var excludedTag: String?

    func getIncludedTag() -> String? {
        return includedTag
    }

    func setIncludedTag(_ newValue: String) {
        includedTag = newValue
    }

    func getExcludedTag() -> String? {
        return excludedTag
    }

    func setExcludedTag(_ newValue: String) {
        excludedTag = newValue
    }
}
