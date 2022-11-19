//
//  APIClient.swift
//  Abydos
//
//  Created by tokizo on 2022/11/16.
//

import Foundation

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

    func fetch() {
        guard let url = url else {
            return
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
        _ = URLSession(configuration: urlSessionConfiguration).dataTask(with: urlRequest) { data, response, error in
            if let error {
                print(error)
                return
            }

            guard let data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                return
            }

            do {
                let pagesResponse = try JSONDecoder().decode(PagesResponse.self, from: data)
                print(pagesResponse)
            } catch {
                print(error)
                return
            }

        }.resume()

    }
}
