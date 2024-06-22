//
//  MockTestModelProvider.swift
//  GithubMobileTests
//
//  Created by Ankush Kushwaha on 20/06/24.
//

import Foundation
@testable import GithubMobile

struct MockModelProvider {

    func userList() -> [User]? {
        guard let data = MockJsonData().getJsonData() else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode(UserResponse.self, from: data)
            return decodedData.items
        } catch {
            print(error)
            return nil
        }
    }

    func repoList() -> [Repo]? {
        guard let data = MockJsonData().getRepoJsonData() else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode([Repo].self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }

    func userDetail() -> User? {
        guard let data = MockJsonData().getUserDetailJsonData() else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode(User.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
