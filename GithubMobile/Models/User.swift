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
    let blog: String?
    let followers: Int?
    let following: Int?
    let name: String?
    let hireable: Bool?
    let avatarUrl: String
    let repoUrl: String
    let publicGists: Int?
    let publicRepos: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case blog
        case followers
        case following
        case name
        case hireable
        case avatarUrl = "avatar_url"
        case repoUrl = "repos_url"
        case publicGists = "public_gists"
        case publicRepos = "public_repos"
    }
}

extension User {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

struct UserResponse: Codable {
    let items: [User]
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }
}
