//
//  UserDetailService.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 20/06/24.
//

import Foundation

struct UserDetailService: UserDetailServiceProtocol {
    
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchRepo(urlString: String) async -> Result<[Repo], Error> {
        await fetch(type: [Repo].self, url: urlString)
    }
    
    func fetchUserDetail(userName: String) async -> Result<User, Error> {
        let urlString = "\(Endpoints().userDetails)\(userName)"
        return await fetch(type: User.self, url: urlString)
    }
    
    private func fetch<T: Decodable>(type: T.Type,
                                     url: String) async -> Result<T, Error> {
        
        guard let url = URL(string: url) else {
            return .failure(NetworkingError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(Constants.accessToken)",
                         forHTTPHeaderField: "Authorization")
        
        do {
            
            let (data, response) = try await session.fetchData(type: type,
                                                               request: request)
            
            let model = try JSONDecoder().decode(type.self, from: data)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkingError.requestFailed("No http response."))
            }
            
            if (400...599).contains(httpResponse.statusCode) {
                return .failure(NetworkingError.httpError(httpResponse.statusCode))
            }
            return .success(model)
            
        } catch {
            return .failure(error)
        }
    }
    
}

protocol UserDetailServiceProtocol {
    func fetchRepo(urlString: String) async -> Result<[Repo], Error>
    func fetchUserDetail(userName: String) async -> Result<User, Error>
}
