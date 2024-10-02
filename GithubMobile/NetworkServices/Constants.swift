//
//  Constants.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 22/06/24.
//

import Foundation

struct Constants {
    static let accessToken = "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"
}

struct Endpoints {
    private let baseUrl = "https://api.github.com"
    
    
    var search: String {
        "\(baseUrl)/search/users?q="
    }
    
    var userDetails: String {
        "\(baseUrl)/users/"
    }
}
