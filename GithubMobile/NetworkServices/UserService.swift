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
    
    func fetchUserList(searchQuery: String, page: Int, usersPerPage: Int) async -> Result<UserResponse, Error> {
        
        let urlString = "\(Endpoints().search)\(searchQuery)&per_page=\(usersPerPage)&page=\(page)"
        guard let url = URL(string: urlString) else {
            return .failure(NetworkingError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(Constants.accessToken)",
                         forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await session.fetchData(type: UserResponse.self, request: request)
            
            let responseModel = try JSONDecoder().decode(UserResponse.self, from: data)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkingError.requestFailed("No http response."))
            }
            
            if (400...599).contains(httpResponse.statusCode) {
                return .failure(NetworkingError.httpError(httpResponse.statusCode))
            }
            
            return .success(responseModel)
        } catch {
            return .failure(error)
        }
        
    }
}

protocol UserServiceProtocol {
    func fetchUserList(searchQuery: String, page: Int, usersPerPage: Int) async -> Result<UserResponse, Error>
}

protocol URLSessionProtocol {
    func fetchData<T>(type: T.Type,
                      request: URLRequest) async throws -> (Data, URLResponse)
    
}

extension URLSession: URLSessionProtocol {
    
    func fetchData<T>(type: T.Type,
                      request: URLRequest) async throws -> (Data, URLResponse) {
        
        try await self.data(for: request)
    }
}
