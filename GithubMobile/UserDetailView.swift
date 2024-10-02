//
//  UserDetailView.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 15/06/24.
//

import SwiftUI

struct UserDetailView: View {
    @ObservedObject private var viewModel: UserDetailViewModel
    
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ZStack {
                mainView()
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text(error.errorMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .task {
            viewModel.fetchData()
        }
    }
}

extension UserDetailView {
    
    @ViewBuilder
    private func mainView() -> some View {
        
        VStack {
            
            AsyncImageView(imageUrl: viewModel.imageUrl,
                           size: .large)
            
            Text(viewModel.userName)
                .font(.system(size: 15, weight: .medium))
                .padding(.bottom, 10)
            
            informationView()
            
            blogLink()
            
            if !viewModel.isLoading {
                
                if viewModel.error == nil,
                   viewModel.repos.isEmpty {
                    Text("No public repo found")
                } else if !viewModel.repos.isEmpty {
                    
                    Divider()
                    
                    VStack {
                        HStack {
                            Text("Public repositories:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .font(.system(size: 16, weight: .semibold))
                            
                            Spacer()
                            
                            ToggleCheckmarkView(isChecked: $viewModel.showForkedRepos, title: "Show Forked: ")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            repoListView()
        }
    }
    
    @ViewBuilder
    private func repoListView() -> some View {
        
        List {
            ForEach(viewModel.filteredRepo, id: \.name) { repo in
                RepoListItem(repo: repo)
                    .onAppear {
                        // Check if the item is the last one
                        if repo == viewModel.repos.last {
                            
                            viewModel.fetchNextRepoPage()
                        }
                    }
            }
            
            // Add ProgressView at last of the list, to indicate load more is in progress
            if viewModel.isMoreRepoItemsAvailable {
                ProgressView()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .listStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    @ViewBuilder
    private func blogLink() -> some View {
        Button {
            if !viewModel.blog.isEmpty, let url = URL(string: viewModel.blog) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack {
                Text("Blog: ")
                    .foregroundColor(.black)
                    .font(.system(size: 15, weight: .light))
                +
                Text(viewModel.blog)
                    .font(.system(size: 15, weight: .light))
                    .foregroundColor(.blue)
                    .underline()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
        }
    }
    
    @ViewBuilder
    private func informationView() -> some View {
        
        VStack(spacing: 8) {
            
            HStack(alignment: .top, spacing: 5) {
                Text("Name: \(viewModel.name)")
                    .font(.system(size: 15, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text("Hireable: \(viewModel.hireable)")
                    .font(.system(size: 15, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            HStack(alignment: .top, spacing: 5) {
                Text("Followers: \(viewModel.followers)")
                    .font(.system(size: 15, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text("Following: \(viewModel.followings)")
                    .font(.system(size: 15, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            HStack(alignment: .top, spacing: 5) {
                Text("Public Repos: \(viewModel.publicRepos)")
                    .font(.system(size: 15, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text("Public Gist: \(viewModel.publicGists)")
                    .font(.system(size: 15, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .padding(.horizontal, 16)
    }
}
