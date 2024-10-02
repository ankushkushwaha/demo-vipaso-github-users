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
    @Published var showForkedRepos = false

    private let service: UserDetailServiceProtocol
    var currentRepoPage = 1 // API returns same data for page 0 and 1, So we begin with 1
    private let reposPerPage = 15

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

    func fetchNextRepoPage() {
        
        if currentRepoPage == totalRepoPages {
            return // Last page is reached
        }
        
        currentRepoPage += 1
        
        Task {
            await fetchRepo(page: currentRepoPage)
        }
    }
    
    @MainActor func fetchRepo(page: Int = 1) async {
//        print("Fetch: page: \(page)")
        
        isLoading = true
        error = nil

        let url = user.repoUrl + "?per_page=10&page=\(page)"
        let result = await service.fetchRepo(urlString: url)

        isLoading = false

        switch result {
        case .success(let data):
            repos.append(contentsOf: data)

        case .failure(let err):
            print(err)
            // set custom NetworkingError for better user experience.
            error = NetworkingError.requestFailed(err.localizedDescription)
        }
    }

    @MainActor func fetchUserDetail() async {
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
}

extension UserDetailViewModel {
    
    var totalRepoPages: Int {
        guard let publicRepos = user.publicRepos else {
            return 1
        }
        
        var totalPage = publicRepos / reposPerPage
        if publicRepos % reposPerPage != 0 {
            totalPage += 1
        }
        return totalPage
    }
    
    var filteredRepo: [Repo] {
        
        if showForkedRepos {
            return repos
        }
        return repos.filter { !$0.isForked }
    }
    
    var isMoreRepoItemsAvailable: Bool {
        currentRepoPage < totalRepoPages
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
        return ""
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

    var name: String {
        if let value = user.name {
            return String(value)
        }
        return "-"
    }

    var hireable: String {
        guard let value = user.hireable else {
            return "-"
        }
        let hireable = value ? "Yes" : "No"

        return hireable
    }

}
