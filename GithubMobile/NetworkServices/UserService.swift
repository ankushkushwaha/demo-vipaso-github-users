//
//  UserService.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 20/06/24.
//

import Foundation

struct UserService: UserServiceProtocol {
    
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchUserList(searchQuery: String) async -> Result<[User], Error> {
        
        let urlString = "https://api.github.com/search/users?q=\(searchQuery)"
        guard let url = URL(string: urlString) else {
            return .failure(NetworkingError.invalidURL)
        }
        
        do {
            let (data, response) = try await session.fetchData(url: url)
            
            let users = try JSONDecoder().decode(UserResponse.self, from: data)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkingError.requestFailed(description: "No http response."))
            }
            
            if (400...599).contains(httpResponse.statusCode) {
                return .failure(NetworkingError.httpError(httpResponse.statusCode))
            }
            
            return .success(users.items)
        } catch {
            return .failure(error)
        }
        
    }
}

protocol UserServiceProtocol {
    func fetchUserList(searchQuery: String) async -> Result<[User], Error>
}

protocol URLSessionProtocol {
    func fetchData(url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func fetchData(url: URL) async throws -> (Data, URLResponse) {
        try await self.data(from: url)
    }
}
