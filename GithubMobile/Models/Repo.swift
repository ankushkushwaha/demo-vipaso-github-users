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
    let language: String?
    let description: String?
    let stargazersCount: Int
    let forkCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case language
        case description
        case stargazersCount = "stargazers_count"
        case forkCount = "forks_count"
    }
}

extension Repo {
    static func == (lhs: Repo, rhs: Repo) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name
    }
}
