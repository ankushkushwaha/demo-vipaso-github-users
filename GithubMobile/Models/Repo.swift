//
//  Repo.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 20/06/24.
//

import Foundation

struct Repo: Codable, Equatable {
    let id: Int
    let name: String
    let language: String
    let stargazersCount: String
    let forkCount: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case language
        case stargazersCount = "stargazers_count"
        case forkCount = "forks_count"
        case description
    }
}

extension Repo {
    static func == (lhs: Repo, rhs: Repo) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name
    }
}
