//
//  Translator.swift
//  Abydos
//
//  Created by tokizo on 2022/11/19.
//

import Foundation

struct Translator {
    struct Option {
        let includedTag: String?
        let excludedTag: String?
    }

    static func translate(_ pagesResponse: PagesResponse, option: Option) -> StatusItemModel? {
        var updated = Int.min
        var bookTitle: String?

        for page in pagesResponse.pages {
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
        let hasContainsIncludedTag: Bool = {
            if let includedTag = option.includedTag {
                return text.contains(includedTag)
            } else {
                return true
            }
        }()
        let hasNotContainsExcludedTag: Bool = {
            if let excludedTag = option.excludedTag {
                return !text.contains(excludedTag)
            } else {
                return true
            }
        }()

        return hasContainsIncludedTag && hasNotContainsExcludedTag
    }
}
