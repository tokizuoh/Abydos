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

    private var targetTag: String?

    func getTargetTag() -> String? {
        return targetTag
    }

    func setTargetTag(_ newValue: String) {
        targetTag = newValue
    }
}
