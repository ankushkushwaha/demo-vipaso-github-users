//
//  AsyncImageView.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 28/09/24.
//

import Foundation
import SwiftUI

struct AsyncImageView: View {
    enum Size {
        case small
        case large
    }

    private let size: Size
    private let imageUrl: String

    init(imageUrl: String, size: Size = .small) {
        self.imageUrl = imageUrl
        self.size = size
    }
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            let size = self.size == .small ? 50.0 : 80.0
            let padding = 10.0

            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else if phase.error != nil {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size - padding, height: size - padding)
                    .foregroundColor(.gray)
                    .padding(padding)
                    .clipShape(Circle())
            } else {
                // Placeholder while loading
                ProgressView()
                    .frame(width: size, height: size)
            }
        }
    }
}
