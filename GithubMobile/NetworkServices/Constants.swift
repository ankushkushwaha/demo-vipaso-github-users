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
