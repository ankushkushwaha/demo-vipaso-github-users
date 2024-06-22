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

    @Published var data: [User] = []
    @Published var isLoading: Bool = false
    @Published var error: NetworkingError?
    @Published var searchText: String = ""

    private let service: UserServiceProtocol

    private let throttleMiliSeconds = 1000
    private let minimumBaseKeyStrokeLength = 2

    private var cancellables = Set<AnyCancellable>()

    init(service: UserServiceProtocol = UserService()) {
        self.service = service

        // Observer for searchText publisher
        $searchText
            .debounce(for: .milliseconds(throttleMiliSeconds), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in

                if searchText.isEmpty {
                    self?.data = []
                } else if let minimumBaseKeyStrokeLength = self?.minimumBaseKeyStrokeLength,
                          searchText.count >= minimumBaseKeyStrokeLength {
                    self?.searchFor(searchText)
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func fetchUsers(searchText: String) async {

        isLoading = true
        error = nil

        let result = await service.fetchUserList(searchQuery: searchText)

        isLoading = false

        switch result {
        case .success(let users):
            data = users
           if users.isEmpty {
               error = NetworkingError.noSearchResultsAvailable("No search results.")
            }

        case .failure(let err):
            print(err)
            // set custom NetworkingError for better user experience.
            error = NetworkingError.requestFailed(err.localizedDescription)
        }
    }

    private func searchFor(_ searchText: String) {
        Task {
            await fetchUsers(searchText: searchText)
        }
    }
}
