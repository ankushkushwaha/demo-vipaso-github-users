//
//  UserListView.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 15/06/24.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                mainView()
                
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.error == nil,
                          viewModel.data.isEmpty {
                    Text("Please try to search Github user.")
                } else if let error = viewModel.error {
                    Text(error.errorMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
    }
}

extension UserListView {
    
    private func mainView() -> some View {
        NavigationStack {
            List(viewModel.data) { user in
                NavigationLink(destination:
                                UserDetailView(viewModel: UserDetailViewModel(user: user))) {
                    
                    AsyncImageView(imageUrl: user.avatarUrl)
                    
                    Text(user.login)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Github Users")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $viewModel.searchText, prompt: "Search")
    }
}

#Preview {
    UserListView()
}
