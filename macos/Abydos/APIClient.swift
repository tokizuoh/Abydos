//
//  APIClient.swift
//  Abydos
//
//  Created by tokizo on 2022/11/16.
//

import Foundation

enum AbydosError: Error {
    case invalidURL
    case invalidServerResponse
}

final class APIClient {
    let url: URL?
    let cookieKey: String
    let cookieValue: String

    init(
        url: URL?,
        cookieKey: String,
        cookieValue: String
    ) {
        self.url = url
        self.cookieKey = cookieKey
        self.cookieValue = cookieValue
    }

    func fetch() async throws -> PagesResponse {
        guard let url = url else {
            throw AbydosError.invalidServerResponse
        }
        let urlRequest = URLRequest(url: url)

        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.httpCookieAcceptPolicy = .onlyFromMainDocumentDomain
        urlSessionConfiguration.httpShouldSetCookies = true
        let cookie = HTTPCookie.cookies(
            withResponseHeaderFields: ["Set-Cookie": "\(cookieKey)=\(cookieValue)"],
            for: url
        )
        urlSessionConfiguration.httpCookieStorage?.setCookie(cookie[0])

        let (data, response) = try await URLSession(configuration: urlSessionConfiguration).data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AbydosError.invalidServerResponse
        }

        let pagesResponse = try JSONDecoder().decode(PagesResponse.self, from: data)

        return pagesResponse
    }
}
