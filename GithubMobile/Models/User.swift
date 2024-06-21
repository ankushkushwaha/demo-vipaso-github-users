//
//  User.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 15/06/24.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: Int
    let login: String
    let avatarUrl: String
    let repoUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case repoUrl = "repos_url"
    }
}

struct UserResponse: Codable {
    let items: [User]
}
