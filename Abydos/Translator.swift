//
//  Translator.swift
//  Abydos
//
//  Created by tokizo on 2022/11/19.
//

import Foundation

struct Translator {
    static let excludedTag = "#読了"
    static let excludedTitle = "Terminal: Book"

    struct Option {
        let includedTag: String?
    }

    static func translate(_ pagesResponse: PagesResponse, _ option: Option) -> StatusItemModel? {
        var updated = Int.min
        var bookTitle: String?

        for page in pagesResponse.pages {
            guard page.title != excludedTitle else {
                continue
            }

            for description in page.descriptions where validate(description, option: option) {
                guard let pageUpdated = page.updated else {
                    continue
                }

                if updated < pageUpdated {
                    updated = pageUpdated
                    bookTitle = page.title
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

    static func validate(_ text: String, option: Option) -> Bool {
        if let includedTag = option.includedTag {
            return text.contains(includedTag) && !text.contains(excludedTag)
        }

        return !text.contains(excludedTag)
    }
}
