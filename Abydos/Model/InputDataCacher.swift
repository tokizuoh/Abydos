//
//  InputDataCacher.swift
//  Abydos
//
//  Created by tokizo on 2022/11/26.
//

import Foundation

actor InputDataCacher {
    static var shared = InputDataCacher()

    private init() {}

    private var includedTag: String?
    private var excludedTag: String?

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
