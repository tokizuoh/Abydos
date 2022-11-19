//
//  APIClient.swift
//  Abydos
//
//  Created by tokizo on 2022/11/16.
//

import Foundation

final class APIClient {
    func fetch() {
        guard let url = Dummy.url else {
            return
        }
        let urlRequest = URLRequest(url: url)

        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.httpCookieAcceptPolicy = .onlyFromMainDocumentDomain
        urlSessionConfiguration.httpShouldSetCookies = true
        let cookie = HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie": "\(Dummy.key)=\(Dummy.value)"], for: url)
        urlSessionConfiguration.httpCookieStorage?.setCookie(cookie[0])
        let task = URLSession(configuration: urlSessionConfiguration).dataTask(with: urlRequest) { data, response, error in
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
