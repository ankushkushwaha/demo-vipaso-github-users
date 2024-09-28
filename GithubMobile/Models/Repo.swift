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
    
    static func == (lhs: Repo, rhs: Repo) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name
    }
}

