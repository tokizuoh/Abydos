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

    func getIncludedTag() -> String? {
        return includedTag
    }

    func setIncludedTag(_ newValue: String) {
        includedTag = newValue
    }
}
