//
//  NetworkingError.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 20/06/24.
//

import Foundation

enum NetworkingError: Error {
    
    case invalidURL
    case requestFailed(String)
    case noSearchResultsAvailable(_ description: String?)
    case httpError(Int)
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return String(localized: "Invalid Url")
        case .requestFailed(let message):
            return message
        case .noSearchResultsAvailable:
            return String(localized: "No search results available for entered keyword.")
        case .httpError(let errorCode):
            return "Error: \(errorCode)"
        }
    }
    
    var errorId: Int {
        switch self {
        case .invalidURL:
            return 1
        case .requestFailed:
            return 2
        case .noSearchResultsAvailable:
            return 3
        case .httpError:
            return 4
        }
    }
}
