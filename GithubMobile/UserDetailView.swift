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
    func mainView() -> some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
            } placeholder: {
                if viewModel.error == nil {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            }

            Text(viewModel.userName)
                .font(.headline)
                .padding()
            
            HStack {
                Text("Followers: \(viewModel.followers)")
                    .padding(.leading)
                Spacer()
                Text("Following: \(viewModel.followings)")
                    .padding(.trailing)
            }
            
            HStack {
                Text("Public Repos: \(viewModel.publicRepos)")
                    .padding(.leading)
                Spacer()
                Text("Public Gist: \(viewModel.publicGists)")
                    .padding(.trailing)
           }
        
            Text("Blog: \(viewModel.blog)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()


            if !viewModel.isLoading {

                if viewModel.error == nil,
                   viewModel.repos.isEmpty {
                    Text("No public repo found")
                } else if !viewModel.repos.isEmpty {
                    Text("Public repo list: ")
                        .padding(.horizontal)
                }
            }

            List(viewModel.repos, id: \.name) { repo in
                Text(repo.name)
            }
        }
    }
}
