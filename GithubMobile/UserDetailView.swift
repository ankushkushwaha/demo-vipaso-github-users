//
//  UserDetailView.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 15/06/24.
//

import SwiftUI

struct UserDetailView: View {
    var user: User
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
            
            Text(user.login)
                .font(.headline)
                .padding()
        }
        
        Spacer()
    }
}
