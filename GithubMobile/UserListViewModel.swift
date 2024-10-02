//
//  UserListViewModel.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 15/06/24.
//

import Foundation
import SwiftUI
import Combine

class UserListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var searchText = ""
    
    @Published var showError = false
    var error: NetworkingError?
    
    private var currentPage = 1 // API returns same data for page 0, and 1
    private var usersPerPage = 12
    private var totalCount: Int?
    
    private let service: UserSearchServiceProtocol
    
    private let throttleMiliSeconds = 1000
    private let minimumBaseKeyStrokeLength = 2
    
    private var cancellables = Set<AnyCancellable>()
    
    init(service: UserSearchServiceProtocol = UserSearchService()) {
        self.service = service
        
        // Observer for searchText publisher
        $searchText
            .debounce(for: .milliseconds(throttleMiliSeconds), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                
                if searchText.isEmpty {
                    
                    self?.resetData()
                    
                } else if let minimumBaseKeyStrokeLength = self?.minimumBaseKeyStrokeLength,
                          searchText.count >= minimumBaseKeyStrokeLength {
                    
                    self?.resetData()
                    
                    self?.searchText = searchText
                    
                    self?.searchFor(searchText, page: 1)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor func fetchUsers(searchText: String, page: Int) async {
        
//        print("Users fetch page: \(page)")
        
        isLoading = true
        error = nil
        
        let result = await service.fetchUserList(searchQuery: searchText,
                                                 page: page, usersPerPage: usersPerPage)
        isLoading = false
        
        switch result {
        case .success(let response):
            
            totalCount = response.totalCount
            
            users.append(contentsOf: response.items)
            
            if users.isEmpty {
                error = NetworkingError.noSearchResultsAvailable("No search results.")
            }
            
        case .failure(let err):
            print(err)
            // set custom NetworkingError for better user experience.
            let message = err.localizedDescription
            error = NetworkingError.requestFailed(message)
            
            showError = true
        }
    }
    
    private func searchFor(_ searchText: String, page: Int) {
        Task {
            await fetchUsers(searchText: searchText, page: page)
        }
    }
    
    func fetchNextPage() {
        
        if currentPage == totalPages {
            return // Last page is reached
        }
        
        currentPage += 1
        
        Task {
            await fetchUsers(searchText: searchText, page: currentPage)
        }
    }
    
    private func resetData() {
        
        self.users = []
        self.totalCount = nil
    }
}


extension UserListViewModel {
    var totalPages: Int {
        guard let totalUserCount = totalCount else {
            return 1
        }
        
        var totalPage = totalUserCount / usersPerPage
        if totalUserCount % usersPerPage != 0 {
            totalPage += 1
        }
        return totalPage
    }
    
    var isMoreSearchResultsAvailable: Bool {
        currentPage < totalPages
    }
}
