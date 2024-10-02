//
//  RepoListItem.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 02/10/24.
//

import SwiftUI

struct RepoListItem: View {
    let repo: Repo
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 5) {
                Text(repo.name)
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text("Language: \(repo.language ?? "-")" )
                    .font(.system(size: 15, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            HStack(alignment: .top, spacing: 5) {
                Text("Stars: \(repo.stargazersCount)")
                    .font(.system(size: 15, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text("Forks: \(repo.forkCount)")
                    .font(.system(size: 15, weight: .light))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            Text("\(repo.description ?? "-")")
                .lineSpacing(8)
                .font(.system(size: 15, weight: .light))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
            
            if repo.isForked {
                Text("isForked: \(repo.isForked)")
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    RepoListItem(
        repo: Repo(
            id: 1,
            name: "Repo",
            language: "swift",
            description: "des",
            stargazersCount: 1,
            forkCount: 2,
            isForked: false,
            htmlUrl: ""
        )
    )
}
