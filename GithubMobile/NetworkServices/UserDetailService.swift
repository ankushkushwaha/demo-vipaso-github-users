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
        await fetch(type: [Repo].self, url: urlString)
    }
    
    func fetchUserDetail(userName: String) async -> Result<User, Error> {
        let urlString = "https://api.github.com/users/\(userName)"
        return await fetch(type: User.self, url: urlString)
    }
    
    private func fetch<T: Decodable>(type: T.Type,
                                     url: String) async -> Result<T, Error> {
        
        guard let url = URL(string: url) else {
            return .failure(NetworkingError.invalidURL)
        }

        do {
            let (data, response) = try await session.fetchData(type: type, url: url)

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

protocol UserDetailSessionProtocol {
    // Inject generic T.Type for unit tests
    func fetchData<T>(type: T.Type, url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: UserDetailSessionProtocol {
    func fetchData<T>(type: T.Type, url: URL) async throws -> (Data, URLResponse) {
        try await self.data(from: url)
    }
}
