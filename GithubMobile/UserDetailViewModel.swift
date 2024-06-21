//
//  UserDetailViewModel.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 20/06/24.
//

import Foundation

class UserDetailViewModel: ObservableObject {

    @Published var repos: [Repo] = []
    @Published var user: User
    @Published var isLoading: Bool = false
    @Published var error: NetworkingError?
    
    private let service: UserDetailServiceProtocol

    init(user: User,
         service: UserDetailServiceProtocol = UserDetailService()) {
        self.user = user
        self.service = service
    }

    func fetchData() {
        Task {
            await fetchUserDetail()
            await fetchRepo()
       }
    }
    
    @MainActor
    func fetchRepo() async {
        isLoading = true
        error = nil

        let result = await service.fetchRepo(urlString: user.repoUrl)

        isLoading = false

        switch result {
        case .success(let data):
            repos = data

        case .failure(let err):
            print(err)
            // set custom NetworkingError for better user experience.
            error = NetworkingError.requestFailed(err.localizedDescription)
        }
    }
    
    @MainActor
    func fetchUserDetail() async {
        isLoading = true
        error = nil

        let result = await service.fetchUserDetail(userName: user.login)

        isLoading = false

        switch result {
        case .success(let data):
            user = data

        case .failure(let err):
            print(err)
            // set custom NetworkingError for better user experience.
            error = NetworkingError.requestFailed(err.localizedDescription)
        }
    }

    var imageUrl: String {
        user.avatarUrl
    }

    var userName: String {
        user.login
    }
    
    var followers: String {
        if let followers = user.followers {
            return String(followers)
        }
        return "-"
    }

    var followings: String {
        if let following = user.following {
            return String(following)
        }
        return "-"
    }
    
    var blog: String {
        if let value = user.blog {
            return String(value)
        }
        return "-"
    }
    
    var publicGists: String {
        if let value = user.publicGists {
            return String(value)
        }
        return "-"
    }
    
    var publicRepos: String {
        if let value = user.publicRepos {
            return String(value)
        }
        return "-"
    }
}
