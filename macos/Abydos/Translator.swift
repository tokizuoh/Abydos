//
//  Translator.swift
//  Abydos
//
//  Created by tokizo on 2022/11/19.
//

import Foundation

struct Translator {
    static let targetTag = "#book"
    static let excludedTag = "#読了"
    static let excludedTitle = "Terminal: Book"

    static func translate(_ pagesResponse: PagesResponse) -> String? {
        var updated = Int.min
        var bookTitle: String?

        for page in pagesResponse.pages {
            guard page.title != excludedTitle else {
                continue
            }

            for description in page.descriptions {
                if description.contains(targetTag) && !description.contains(excludedTag) {
                    guard let pageUpdated = page.updated else {
                        continue
                    }

                    if updated < pageUpdated {
                        updated = pageUpdated
                        bookTitle = page.title
                    }
                }
            }
        }
        return bookTitle
    }
}
