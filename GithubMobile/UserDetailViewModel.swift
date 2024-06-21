//
//  UserDetailViewModel.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 20/06/24.
//

import Foundation

class UserDetailViewModel: ObservableObject {
   
    @Published var repos: [Repo] = []
    @Published var isLoading: Bool = false
    @Published var error: NetworkingError?

    private let user: User
    private let service: UserDetailServiceProtocol

    init(user: User, service: UserDetailServiceProtocol = UserDetailService()) {
        self.user = user
        self.service = service
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
    
    var imageUrl: String {
        user.avatarUrl
    }
    
    var userName: String {
        user.login
    }
}
