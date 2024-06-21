//
//  UserDetailService.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 20/06/24.
//

import Foundation

struct UserDetailService: UserDetailServiceProtocol {
    
    var session: UserDetailSessionProtocol
    
    init(session: UserDetailSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchRepo(urlString: String) async -> Result<[Repo], Error> {
        
        guard let url = URL(string: urlString) else {
            return .failure(NetworkingError.invalidURL)
        }
        
        do {
            let (data, response) = try await session.fetchData(url: url)
            
            let models = try JSONDecoder().decode([Repo].self, from: data)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkingError.requestFailed("No http response."))
            }
            
            if (400...599).contains(httpResponse.statusCode) {
                return .failure(NetworkingError.httpError(httpResponse.statusCode))
            }
            
            return .success(models)
        } catch {
            return .failure(error)
        }
        
    }
}

protocol UserDetailServiceProtocol {
    func fetchRepo(urlString: String) async -> Result<[Repo], Error>
}

protocol UserDetailSessionProtocol {
    func fetchData(url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: UserDetailSessionProtocol {
    func fetchRepo(url: URL) async throws -> (Data, URLResponse) {
        try await self.data(from: url)
    }
}
