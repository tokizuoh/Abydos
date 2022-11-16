//
//  PagesResponse.swift
//  Abydos
//
//  Created by tokizo on 2022/11/16.
//

struct User: Codable {
    let id: String?
}

struct Page: Codable {
    let id: String?
    let title: String?
    let image: String?
    let descriptions: [String]
    let user: User
    let pin: Int64
    let views: Int?
    let linked: Int?
    let commitId: String?
    let created: Int?
    let updated: Int?
    let accessed: Int?
    let snapshotCreated: Int?
    let pageRank: Int?
}

struct PagesResponse: Codable {
    let projectName: String?
    let skip: Int?
    let limit: Int?
    let count: Int?
    let pages: [Page]
}
