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

    static func translate(_ pagesResponse: PagesResponse) -> StatusItemModel? {
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

        guard let bookTitle,
              let encodedBookTitle = bookTitle.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return nil
        }

        return StatusItemModel(
            title: bookTitle,
            urlString: "https://scrapbox.io/\(pagesResponse.projectName)/\(encodedBookTitle)"
        )
    }
}
