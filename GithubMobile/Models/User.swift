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
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }
}

struct UserResponse: Codable {
    let items: [User]
}
