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
                    Text("Please try to search user.")
                } else if let error = viewModel.error {
                    Text(error.errorMessage)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

extension UserListView {
    
    private func mainView() -> some View {
        NavigationStack {
                List(viewModel.data) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        Text(user.login)
                    }
                }
                .listStyle(.plain)
            .navigationTitle("Github Users")
        }
        .searchable(text: $viewModel.searchText, prompt: "Search")
    }
}

#Preview {
    UserListView()
}
