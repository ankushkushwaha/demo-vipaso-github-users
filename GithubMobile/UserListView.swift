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
                          viewModel.users.isEmpty {
                    Text("Please try to search Github user.")
                }
            }
            .customAlert(showAlert: $viewModel.showError, title: "",
                         message: viewModel.error?.errorMessage ?? "-")
        }
    }
}

extension UserListView {
    
    private func mainView() -> some View {
        
        NavigationStack {
            
            List {
                ForEach (viewModel.users) { user in
                    NavigationLink(destination:
                                    UserDetailView(viewModel: UserDetailViewModel(user: user))) {
                        
                        AsyncImageView(imageUrl: user.avatarUrl)
                        
                        Text(user.login)
                            .onAppear {
                                
                                // Check if the item is the last one
                                if user == viewModel.users.last {
                                    
                                    viewModel.fetchNextPage()
                                }
                            }
                    }
                }
                
                if viewModel.isMoreSearchResultsAvailable {
                    ProgressView()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
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
